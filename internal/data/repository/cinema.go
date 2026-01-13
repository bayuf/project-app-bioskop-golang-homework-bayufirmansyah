package repository

import (
	"context"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
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
