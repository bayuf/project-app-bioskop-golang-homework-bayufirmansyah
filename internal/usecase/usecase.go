package usecase

import (
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

type UseCase struct {
	*AuthUsecase
	*EmailUsecase
	*CinemaUseCase
	*MovieUseCase
	*BookingUseCase
}

func NewUsecase(repo *repository.Repository, log *zap.Logger, config *utils.Configuration, tx database.TxManager, emailJob chan<- utils.EmailJob) *UseCase {
	return &UseCase{
		AuthUsecase:    NewAuthUsecase(repo.AuthRepository, log, config, tx, emailJob),
		EmailUsecase:   NewEmailUsecase(log, config),
		CinemaUseCase:  NewCinemaUseCase(repo.CinemaRepository, log),
		MovieUseCase:   NewMovieUseCase(repo.MovieRepository, log),
		BookingUseCase: NewBookingUseCase(repo.BookingRepository, log, tx),
	}
}
