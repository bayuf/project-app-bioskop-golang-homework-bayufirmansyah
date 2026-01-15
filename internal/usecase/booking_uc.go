package usecase

import (
	"context"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

type BookingUseCase struct {
	repo   *repository.BookingRepository
	logger *zap.Logger
	tx     database.TxManager
}

func NewBookingUseCase(repo *repository.BookingRepository, logger *zap.Logger, tx database.TxManager) *BookingUseCase {
	return &BookingUseCase{
		repo:   repo,
		logger: logger,
		tx:     tx,
	}
}

func (uc *BookingUseCase) BookingSeat(ctx context.Context, userID uuid.UUID, req dto.BookingReq) error {
	movieInfo, err := uc.repo.GetMovieInfobySchedule(ctx, req.CinemaID, req.Date, req.Time)
	if err != nil {
		return err
	}

	// validate seat exist in studio
	if err != uc.repo.SeatValidation(ctx, req.SeatID, movieInfo.StudioID) {
		return err
	}

	// Begin Transaction
	tx, err := uc.tx.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	repoTx := repository.NewBookingRepository(tx, uc.logger)

	newBookingID := uuid.New()
	if err := repoTx.CreateBooking(ctx, newBookingID, userID, movieInfo.ID, movieInfo.Price); err != nil {
		return err
	}

	if err := repoTx.BookingSeat(ctx, newBookingID, movieInfo.ID, req.SeatID); err != nil {
		return err
	}

	if err := tx.Commit(ctx); err != nil {
		return err
	}

	return nil
}
