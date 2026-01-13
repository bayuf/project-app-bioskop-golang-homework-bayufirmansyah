package adaptor

import (
	"net/http"
	"strconv"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"
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
