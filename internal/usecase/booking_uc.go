package usecase

import (
	"context"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
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

func (uc *BookingUseCase) GetBookingHistory(ctx context.Context, userID uuid.UUID) (*[]dto.BookingHystory, error) {
	bookings, err := uc.repo.GetBookingHistoryByUserId(ctx, userID)
	if err != nil {
		return nil, err
	}

	return bookings, nil
}

func (uc *BookingUseCase) GetBookingDetail(ctx context.Context, bookingID uuid.UUID) (*dto.BookingDetail, error) {
	return uc.repo.GetMyTicketByBookingId(ctx, bookingID)
}

func (uc *BookingUseCase) BookingSeat(ctx context.Context, userID uuid.UUID, req dto.BookingReq) (*dto.BookingRes, error) {
	movieInfo, err := uc.repo.GetMovieInfobySchedule(ctx, req.CinemaID, req.Date, req.Time)
	if err != nil {
		return nil, err
	}

	// validate seat exist in studio
	if err != uc.repo.SeatValidation(ctx, req.SeatID, movieInfo.StudioID) {
		return nil, err
	}

	// Begin Transaction
	tx, err := uc.tx.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback(ctx)

	repoTx := repository.NewBookingRepository(tx, uc.logger)

	newBookingID := uuid.New()
	if err := repoTx.CreateBooking(ctx, newBookingID, userID, movieInfo.ID, movieInfo.Price); err != nil {
		return nil, err
	}

	if err := repoTx.BookingSeat(ctx, newBookingID, movieInfo.ID, req.SeatID); err != nil {
		return nil, err
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}

	return &dto.BookingRes{
		ID:         newBookingID,
		Status:     "Pending",
		TotalPrice: movieInfo.Price,
	}, nil
}

func (uc *BookingUseCase) Confirm(ctx context.Context, detail dto.Payment) error {
	tx, err := uc.tx.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	repoTx := repository.NewBookingRepository(tx, uc.logger)

	// find booking data
	data, err := repoTx.GetBookingData(ctx, detail.BookingID)
	if err != nil {
		return err
	}

	if err := repoTx.ConfirmBooking(ctx, detail.BookingID); err != nil {
		return err
	}

	if err := repoTx.UpdatePayment(ctx, entity.Payment{
		ID:            uuid.New(),
		BookingID:     detail.BookingID,
		PaymentMethod: detail.PaymentMethod,
		Amount:        data.TotalPrice,
		Status:        "SUCCESS",
	}); err != nil {
		return err
	}

	if err := tx.Commit(ctx); err != nil {
		return err
	}
	return nil
}
