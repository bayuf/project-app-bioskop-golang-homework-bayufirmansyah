package adaptor

import (
	"errors"
	"net/http"
	"strconv"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"
)

type MovieAdapter struct {
	repo   *usecase.MovieUseCase
	logger *zap.Logger
	config *utils.Configuration
}

func NewMovieAdapter(repo *usecase.MovieUseCase, logger *zap.Logger, config *utils.Configuration) *MovieAdapter {
	return &MovieAdapter{
		repo:   repo,
		logger: logger,
		config: config,
	}
}

func (ad *MovieAdapter) GetMovieDetail(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if r.Method != "GET" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "failed", errors.New("method not allowed"))
		return
	}

	idStr := chi.URLParam(r, "movie_id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ad.logger.Error("failed to convert id string to int", zap.Error(err))
		utils.ResponseFailed(w, http.StatusBadRequest, "failed", err.Error())
		return
	}

	movie, err := ad.repo.GetMovieDetail(ctx, id)
	if err != nil {
		ad.logger.Error("failed to get movie", zap.Error(err))
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed", err.Error())
		return
	}

	utils.ResponseSuccess(w, http.StatusOK, "success", movie)
}

func (ad *MovieAdapter) GetMovies(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if r.Method != "GET" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "failed", errors.New("method not allowed"))
		return
	}

	category := r.URL.Query().Get("category")
	pageStr := r.URL.Query().Get("page")

	page, err := strconv.Atoi(pageStr)
	if err != nil {
		ad.logger.Error("failed to convert page string to int", zap.Error(err))
		utils.ResponseFailed(w, http.StatusBadRequest, "failed", nil)
		return
	}

	limit := ad.config.PageLimit

	movies, pagination, err := ad.repo.GetMoviesNowShowing(ctx, page, limit, category)
	if err != nil {
		ad.logger.Error("failed to get movies", zap.Error(err))
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed", err.Error())
		return
	}

	utils.ResponsePagination(w, http.StatusOK, "success", movies, *pagination)
}
