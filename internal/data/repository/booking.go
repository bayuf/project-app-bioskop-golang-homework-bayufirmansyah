package repository

import (
	"context"
	"errors"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
	"go.uber.org/zap"
)

type BookingRepository struct {
	db     database.DBExecutor
	logger *zap.Logger
}

func NewBookingRepository(db database.DBExecutor, logger *zap.Logger) *BookingRepository {
	return &BookingRepository{
		db:     db,
		logger: logger,
	}
}

func (br *BookingRepository) GetMovieInfobySchedule(ctx context.Context, cinemaId int, showDate time.Time, showTime time.Time) (*entity.CinemaSchedule,
	error) {

	query := `
	SELECT
    	ms.id, ms.studio_id, ms.price
    FROM movie_schedules ms
    	JOIN studios st ON st.id = ms.studio_id
    WHERE st.cinema_id = $1
    	AND ms.show_date = $2
     	AND ms.show_time = $3
      	AND ms.deleted_at IS NULL;`

	var movie entity.CinemaSchedule
	if err := br.db.QueryRow(ctx, query, cinemaId, showDate, showTime).Scan(&movie.ID, &movie.StudioID, &movie.Price); err != nil {
		br.logger.Error("failed to query cinema by schedule", zap.Error(err))
		return nil, err
	}
	return &movie, nil
}

func (br *BookingRepository) SeatValidation(ctx context.Context, seatId, studioId int) error {
	query := `
	SELECT 1
	FROM seats
	WHERE id = $1
  		AND studio_id = $2
    	AND deleted_at IS NULL;`

	var result int
	if err := br.db.QueryRow(ctx, query, seatId, studioId).Scan(&result); err != nil {
		br.logger.Error("failed to validate seat", zap.Error(err))
		return err
	}
	if result == 0 {
		return errors.New("seat not found")
	}

	return nil
}

func (br *BookingRepository) CreateBooking(ctx context.Context, bookingID, userID, scheduleID uuid.UUID, totalPrice decimal.Decimal) error {
	query := `
	INSERT INTO bookings (id, user_id, schedule_id, total_price, status)
	VALUES ($1, $2, $3, $4, 'RESERVED');`

	if _, err := br.db.Exec(ctx, query, bookingID, userID, scheduleID, totalPrice); err != nil {
		br.logger.Error("failed to reserve booking", zap.Error(err))
		return err
	}
	return nil
}

func (br *BookingRepository) BookingSeat(ctx context.Context, bookingID, scheduleID uuid.UUID, seatID int, bookingStatus string) error {
	query := `
	INSERT INTO booking_seats (booking_id, schedule_id, seat_id, status)
	VALUES ($1, $2, $3, $4);`

	if _, err := br.db.Exec(ctx, query, bookingID, scheduleID, seatID, bookingStatus); err != nil {
		br.logger.Error("failed to book seat", zap.Error(err))
		return err
	}
	return nil
}
