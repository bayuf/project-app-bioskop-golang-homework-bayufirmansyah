package usecase

import (
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

type UseCase struct {
	*AuthUsecase
	*EmailUsecase
	*CinemaUseCase
	*MovieUseCase
}

func NewUsecase(repo *repository.Repository, log *zap.Logger, config *utils.Configuration, emailJob chan<- utils.EmailJob) *UseCase {
	return &UseCase{
		AuthUsecase:   NewAuthUsecase(repo.AuthRepository, log, config, emailJob),
		EmailUsecase:  NewEmailUsecase(log, config),
		CinemaUseCase: NewCinemaUseCase(repo.CinemaRepository, log),
		MovieUseCase:  NewMovieUseCase(repo.MovieRepository, log),
	}
}
