package adaptor

import (
	"net/http"
	"strconv"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"
	"golang.org/x/sync/errgroup"
)

type CinemaAdaptor struct {
	usecase *usecase.CinemaUseCase
	logger  *zap.Logger
	config  *utils.Configuration
}

func NewCinemaAdaptor(usecase *usecase.CinemaUseCase, logger *zap.Logger, config *utils.Configuration) *CinemaAdaptor {
	return &CinemaAdaptor{
		usecase: usecase,
		logger:  logger,
		config:  config,
	}
}

func (ad *CinemaAdaptor) GetListCinemas(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if r.Method != "GET" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "failed", nil)
		return
	}

	page, err := strconv.Atoi(r.URL.Query().Get("page"))
	if err != nil {
		ad.logger.Error("failed to convert page string to int", zap.Error(err))
		utils.ResponseFailed(w, http.StatusBadRequest, "failed", nil)
		return
	}

	limit := ad.config.PageLimit

	cinemas, pagination, err := ad.usecase.GetAllCinemas(ctx, page, limit)
	if err != nil {
		ad.logger.Error("failed to get list cinemas", zap.Error(err))
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed", nil)
		return
	}

	utils.ResponsePagination(w, http.StatusOK, "success", cinemas, *pagination)
}

func (ad *CinemaAdaptor) GetCinema(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if r.Method != "GET" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "failed", nil)
		return
	}

	idStr := chi.URLParam(r, "cinema_id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ad.logger.Error("failed to convert id string to int", zap.Error(err))
		utils.ResponseFailed(w, http.StatusBadRequest, "failed", nil)
		return
	}

	cinema, err := ad.usecase.GetCinemaById(ctx, id)
	if err != nil {
		ad.logger.Error("failed to get cinema", zap.Error(err))
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed", nil)
		return
	}

	utils.ResponseSuccess(w, http.StatusOK, "success", cinema)
}

func (ad *CinemaAdaptor) GetSeatStatus(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if r.Method != "GET" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "failed", nil)
		return
	}

	var (
		id        int
		date      time.Time
		timeClock time.Time
	)
	g, _ := errgroup.WithContext(ctx)
	g.Go(func() error {
		var err error
		idStr := chi.URLParam(r, "cinema_id")
		id, err = strconv.Atoi(idStr)
		if err != nil {
			ad.logger.Error("failed to convert id string to int", zap.Error(err))
			return err
		}
		return nil
	})

	g.Go(func() error {
		var err error
		dateStr := r.URL.Query().Get("date")
		date, err = time.Parse("2006-01-02", dateStr)
		if err != nil {
			ad.logger.Error("failed to parse date string", zap.Error(err))
			return err
		}
		return nil
	})

	g.Go(func() error {
		var err error
		timeStr := r.URL.Query().Get("time")
		timeClock, err = time.Parse("15:04:05", timeStr)
		if err != nil {
			ad.logger.Error("failed to parse time string", zap.Error(err))
			return err
		}
		return nil
	})

	if err := g.Wait(); err != nil {
		utils.ResponseFailed(w, http.StatusBadRequest, "failed parse", err.Error())
		return
	}

	seatStatus, err := ad.usecase.GetSeatStatus(ctx, id, date, timeClock)
	if err != nil {
		ad.logger.Error("failed to get seat status", zap.Error(err))
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed", nil)
		return
	}

	utils.ResponseSuccess(w, http.StatusOK, "success", seatStatus)
}
