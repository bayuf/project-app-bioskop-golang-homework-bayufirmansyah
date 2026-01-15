package usecase

import (
	"context"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"go.uber.org/zap"
)

type PaymentUseCase struct {
	repo   *repository.PaymentRepository
	logger *zap.Logger
}

func NewPaymentUseCase(repo *repository.PaymentRepository, logger *zap.Logger) *PaymentUseCase {
	return &PaymentUseCase{
		repo:   repo,
		logger: logger,
	}
}

func (uc *PaymentUseCase) GetPaymentMethods(ctx context.Context) (*[]dto.PaymentRes, error) {
	return uc.repo.GetPaymentMethods(ctx)
}
