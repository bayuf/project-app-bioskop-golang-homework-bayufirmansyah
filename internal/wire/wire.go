package wire

import (
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/adaptor"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"
)

type App struct {
	Route *chi.Mux
}

func Wiring(repo *repository.Repository, logger *zap.Logger, config *utils.Configuration) *App {
	// init
	r := chi.NewRouter()

	WireAPI(r, repo, logger, config)

	return &App{
		Route: r,
	}
}

func WireAPI(route *chi.Mux, repo *repository.Repository, logger *zap.Logger, config *utils.Configuration) {
	// init layer
	uc := usecase.NewUsecase(repo, logger)
	adaptor := adaptor.NewAdaptor(uc, logger, config)

	_ = adaptor
}
