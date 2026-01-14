package usecase

import (
	"context"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

type CinemaUseCase struct {
	repo   *repository.CinemaRepository
	logger *zap.Logger
}

func NewCinemaUseCase(repo *repository.CinemaRepository, logger *zap.Logger) *CinemaUseCase {
	return &CinemaUseCase{
		repo:   repo,
		logger: logger,
	}
}

func (uc *CinemaUseCase) GetAllCinemas(ctx context.Context, page, limit int) (*[]dto.CinemaListResponse, *dto.Pagination, error) {
	cinemas, total, err := uc.repo.GetAllCinemas(ctx, page, limit)
	if err != nil {
		return nil, nil, err
	}

	pagination := dto.Pagination{
		CurrentPage:  page,
		Limit:        limit,
		TotalPages:   utils.TotalPage(limit, int64(total)),
		TotalRecords: total,
	}

	var cinemaResponses []dto.CinemaListResponse
	for _, cinema := range *cinemas {
		cinemaResponses = append(cinemaResponses, dto.CinemaListResponse{
			ID:       cinema.ID,
			Name:     cinema.Name,
			Location: cinema.Location,
		})
	}

	return &cinemaResponses, &pagination, nil
}

func (uc *CinemaUseCase) GetCinemaById(ctx context.Context, id int) (*dto.CinemaDetail, error) {
	cinema, err := uc.repo.GetCinemaByID(ctx, id)
	if err != nil {
		return nil, err
	}

	return &dto.CinemaDetail{
		ID:        cinema.ID,
		Name:      cinema.Name,
		Location:  cinema.Location,
		CreatedAt: cinema.CreatedAt,
		UpdatedAt: cinema.UpdatedAt,
	}, nil
}

func (uc *CinemaUseCase) GetSeatStatus(ctx context.Context, cinemaId int, date, time time.Time) (*[]dto.SeatStatus, error) {
	studioSchedule, err := uc.repo.GetStudioIdbySchedule(ctx, cinemaId, date, time)
	if err != nil {
		return nil, err
	}

	seatStatus, err := uc.repo.GetSeatStatus(ctx, studioSchedule.ID, studioSchedule.StudioID)
	if err != nil {
		return nil, err
	}

	var seatStatusResponses []dto.SeatStatus
	for _, status := range *seatStatus {
		seatStatusResponses = append(seatStatusResponses, dto.SeatStatus{
			SeatID:   status.SeatID,
			SeatCode: status.SeatCode,
			Status:   status.Status,
		})
	}

	return &seatStatusResponses, nil
}
