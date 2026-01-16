package repository

import (
	"context"
	"errors"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
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

func (vr BookingRepository) GetBookingData(ctx context.Context, bookingID uuid.UUID) (*entity.Booking, error) {
	query := `
	SELECT id, user_id, schedule_id, status, total_price
	FROM bookings
	WHERE id = $1
		AND expired_at > NOW()
		AND status = 'RESERVED'`

	var booking entity.Booking
	if err := vr.db.QueryRow(ctx, query, bookingID).Scan(&booking.ID, &booking.UserID, &booking.ScheduleID, &booking.Status, &booking.TotalPrice); err != nil {
		vr.logger.Error("failed to scan booking data", zap.Error(err))
		return nil, err
	}
	return &booking, nil
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
	INSERT INTO bookings (id, user_id, schedule_id, total_price, status, expired_at)
	VALUES ($1, $2, $3, $4, 'RESERVED', NOW() + INTERVAL '10 minute');`

	if _, err := br.db.Exec(ctx, query, bookingID, userID, scheduleID, totalPrice); err != nil {
		br.logger.Error("failed to reserve booking", zap.Error(err))
		return err
	}
	return nil
}

func (br *BookingRepository) BookingSeat(ctx context.Context, bookingID, scheduleID uuid.UUID, seatID int) error {
	query := `
	INSERT INTO booking_seats (booking_id, schedule_id, seat_id)
	VALUES ($1, $2, $3);`

	if _, err := br.db.Exec(ctx, query, bookingID, scheduleID, seatID); err != nil {
		br.logger.Error("failed to book seat", zap.Error(err))
		return err
	}
	return nil
}

func (br *BookingRepository) ConfirmBooking(ctx context.Context, bookingID uuid.UUID) error {
	query := `
	UPDATE bookings
	SET status = 'PAID'
	WHERE id = $1
		AND expired_at > NOW()
		AND status = 'RESERVED';`

	if _, err := br.db.Exec(ctx, query, bookingID); err != nil {
		br.logger.Error("failed to confirm booking", zap.Error(err))
		return err
	}
	return nil
}

func (br *BookingRepository) UpdatePayment(ctx context.Context, detail entity.Payment) error {
	query := `
	INSERT INTO payments (id, booking_id, payment_method_id, amount, status, paid_at)
	VALUES ($1, $2, $3, $4, $5, NOW());`

	if _, err := br.db.Exec(ctx, query, detail.ID, detail.BookingID, detail.PaymentMethod,
		detail.Amount, detail.Status); err != nil {
		br.logger.Error("failed to update payment", zap.Error(err))
		return err
	}
	return nil
}

func (br *BookingRepository) GetBookingHistoryByUserId(ctx context.Context, userID uuid.UUID) (*[]dto.BookingHystory, error) {
	query := `
	SELECT
		m.title, m.poster_url, m.duration_minutes, ms.show_date, c.name, c.location, s.name
	FROM bookings b
		JOIN movie_schedules ms ON ms.id = b.schedule_id
		JOIN studios s ON s.id = ms.studio_id
		JOIN cinemas c ON c.id = s.cinema_id
		JOIN movies m ON m.id = ms.movie_id
    WHERE b.user_id = $1
        AND b.status = 'PAID';`

	rows, err := br.db.Query(ctx, query, userID)
	if err != nil {
		br.logger.Error("failed to get booking history", zap.Error(err))
		return nil, err
	}
	defer rows.Close()

	var bookings []dto.BookingHystory
	for rows.Next() {
		var booking dto.BookingHystory
		if err := rows.Scan(&booking.Title, &booking.PosterUrl, &booking.Duration,
			&booking.Date, &booking.CinemaName, &booking.CinemaLocation, &booking.StudioName); err != nil {
			br.logger.Error("failed to scan booking history", zap.Error(err))
			return nil, err
		}
		bookings = append(bookings, booking)
	}

	return &bookings, nil
}

func (br *BookingRepository) GetMyTicketByBookingId(ctx context.Context, bookingId uuid.UUID) (*dto.BookingDetail, error) {
	query := `
	SELECT
		b.id, m.title, m.poster_url, m.duration_minutes, ms.show_date, ms.show_time, c.name, c.location, s.name,
		b.total_price, se.seat_code
	FROM bookings b
		JOIN movie_schedules ms ON ms.id = b.schedule_id
		JOIN studios s ON s.id = ms.studio_id
		JOIN cinemas c ON c.id = s.cinema_id
		JOIN movies m ON m.id = ms.movie_id
		JOIN booking_seats bs ON bs.booking_id = b.id
		JOIN seats se ON se.id = bs.seat_id
    WHERE b.id = $1
        AND b.status = 'PAID';`

	var booking dto.BookingDetail
	if err := br.db.QueryRow(ctx, query, bookingId).
		Scan(&booking.ID, &booking.Title, &booking.PosterUrl, &booking.Duration,
			&booking.Date, &booking.Time, &booking.CinemaName, &booking.CinemaLocation, &booking.StudioName,
			&booking.TotalAmount, &booking.Seat); err != nil {
		br.logger.Error("failed to scan detail ticket", zap.Error(err))
		return nil, err
	}
	return &booking, nil
}
