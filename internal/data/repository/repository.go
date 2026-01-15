package repository

import (
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"go.uber.org/zap"
)

type Repository struct {
	*AuthRepository
	*CinemaRepository
	*MovieRepository
	*BookingRepository
}

func NewRepository(db database.DBExecutor, log *zap.Logger) *Repository {
	return &Repository{
		AuthRepository:    NewAuthRepository(db, log),
		CinemaRepository:  NewCinemaRepository(db, log),
		MovieRepository:   NewMovieRepository(db, log),
		BookingRepository: NewBookingRepository(db, log),
	}
}
