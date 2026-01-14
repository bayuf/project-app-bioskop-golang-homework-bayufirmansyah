package repository

import (
	"context"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

type CinemaRepository struct {
	db     database.DBExecutor
	logger *zap.Logger
}

func NewCinemaRepository(db database.DBExecutor, logger *zap.Logger) *CinemaRepository {
	return &CinemaRepository{
		db:     db,
		logger: logger,
	}
}

func (cr *CinemaRepository) GetAllCinemas(ctx context.Context, page, limit int) (*[]entity.Cinema, int, error) {
	offset := (page - 1) * limit

	// get total data for pagination
	var total int
	countQuery := `SELECT COUNT(*) FROM cinemas WHERE deleted_at IS NULL`
	err := cr.db.QueryRow(ctx, countQuery).Scan(&total)
	if err != nil {
		cr.logger.Error("error query getAll repo ", zap.Error(err))
		return nil, 0, err
	}

	query := `
	SELECT
		id, name, location
	FROM cinemas
	WHERE deleted_at IS NULL
	ORDER BY id ASC
	LIMIT $1 OFFSET $2;`

	rows, err := cr.db.Query(ctx, query, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var cinemas []entity.Cinema
	for rows.Next() {
		var cinema entity.Cinema
		if err := rows.Scan(&cinema.ID, &cinema.Name, &cinema.Location); err != nil {
			cr.logger.Error("failed to scan cinema", zap.Error(err))
			return nil, 0, err
		}
		cinemas = append(cinemas, cinema)
	}

	return &cinemas, total, nil
}

func (cr *CinemaRepository) GetCinemaByID(ctx context.Context, id int) (*entity.Cinema, error) {
	query := `
	SELECT
		id, name, location, created_at, updated_at
	FROM cinemas
	WHERE id = $1 AND deleted_at IS NULL;`

	row := cr.db.QueryRow(ctx, query, id)

	var cinema entity.Cinema
	if err := row.Scan(&cinema.ID, &cinema.Name, &cinema.Location, &cinema.CreatedAt, &cinema.UpdatedAt); err != nil {
		cr.logger.Error("failed to scan cinema", zap.Error(err))
		return nil, err
	}

	return &cinema, nil
}

func (cr *CinemaRepository) GetStudioIdbySchedule(ctx context.Context, cinemaId int, showDate time.Time, showTime time.Time) (*entity.CinemaSchedule,
	error) {

	query := `
	SELECT
    	ms.id, ms.studio_id
    FROM movie_schedules ms
    	JOIN studios st ON st.id = ms.studio_id
    WHERE st.cinema_id = $1
    	AND ms.show_date = $2
     	AND ms.show_time = $3
      	AND ms.deleted_at IS NULL;`

	var schedule entity.CinemaSchedule
	if err := cr.db.QueryRow(ctx, query, cinemaId, showDate, showTime).Scan(&schedule.ID, &schedule.StudioID); err != nil {
		cr.logger.Error("failed to query cinema by schedule", zap.Error(err))
		return nil, err
	}
	return &schedule, nil
}

func (cr *CinemaRepository) GetSeatStatus(ctx context.Context, scheduleId uuid.UUID, studioId int) (*[]dto.SeatStatus, error) {
	query := `
	SELECT
	    s.id,
	    s.seat_code,
	    CASE
	        WHEN bs.seat_id IS NULL THEN 'AVAILABLE'
	        ELSE 'BOOKED'
	    END AS status
	FROM seats s
		LEFT JOIN booking_seats bs
    	ON bs.seat_id = s.id
     	AND bs.schedule_id = $1
    	AND bs.booking_status IN ('RESERVED', 'PAID')
    WHERE s.studio_id = $2
    	AND s.deleted_at IS NULL
     ORDER BY LENGTH(seat_code), seat_code;`

	rows, err := cr.db.Query(ctx, query, scheduleId, studioId)
	if err != nil {
		cr.logger.Error("failed to query seat status", zap.Error(err))
		return nil, err
	}
	defer rows.Close()

	var seatStatus []dto.SeatStatus
	for rows.Next() {
		var status dto.SeatStatus
		if err := rows.Scan(&status.SeatID, &status.SeatCode, &status.Status); err != nil {
			cr.logger.Error("failed to scan seat status", zap.Error(err))
			return nil, err
		}
		seatStatus = append(seatStatus, status)
	}

	return &seatStatus, nil
}
