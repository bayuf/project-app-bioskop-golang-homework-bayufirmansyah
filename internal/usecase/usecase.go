package usecase

import (
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"go.uber.org/zap"
)

type UseCase struct {
}

func NewUsecase(repo *repository.Repository, log *zap.Logger) *UseCase {
	return &UseCase{}
}
