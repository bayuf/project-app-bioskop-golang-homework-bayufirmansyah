package wire

import (
	"sync"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/adaptor"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	mwCustom "github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/middleware"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"github.com/go-chi/chi/middleware"
	"github.com/go-chi/chi/v5"
	"go.uber.org/zap"
)

type App struct {
	Route *chi.Mux
	Stop  chan struct{}
	WG    *sync.WaitGroup
}

func Wiring(repo *repository.Repository, logger *zap.Logger, config *utils.Configuration) *App {
	// init
	r := chi.NewRouter()

	emailJobs := make(chan utils.EmailJob, 10) // BUFFER
	stop := make(chan struct{})
	metrics := &utils.Metrics{}
	wg := &sync.WaitGroup{}
	emailUC := usecase.NewEmailUsecase(logger, config)

	utils.StartEmailWorkers(3, emailJobs, stop, metrics, wg, emailUC)

	// chi middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	WireAPI(r, repo, logger, config, emailJobs)

	return &App{
		Route: r,
		Stop:  stop,
		WG:    wg,
	}
}

func WireAPI(r *chi.Mux, repo *repository.Repository, logger *zap.Logger, config *utils.Configuration, emailJob chan<- utils.EmailJob) {
	// init layer
	uc := usecase.NewUsecase(repo, logger, config, emailJob)
	adaptor := adaptor.NewAdaptor(uc, logger, config)
	mw := mwCustom.NewCustomMiddleware(repo, logger)

	// routers
	r.Post("/register", adaptor.AuthAdaptor.RegisterUser)

	// auth
	r.Route("/auth", func(r chi.Router) {
		r.Post("/login", adaptor.AuthAdaptor.LoginUser)

		r.Group(func(r chi.Router) {
			r.Use(mw.AuthMiddleware.SessionAuthMiddleware())
			r.Post("/logout", adaptor.AuthAdaptor.LogoutUser)
		})
	})

	r.Route("/cinemas", func(r chi.Router) {
		r.Get("/{cinema_id}", adaptor.CinemaAdaptor.GetCinema)
		r.Get("/", adaptor.CinemaAdaptor.GetListCinemas)
	})

	r.Route("/movies", func(r chi.Router) {
		r.Get("/", adaptor.MovieAdapter.GetMovies)
		r.Get("/{movie_id}", adaptor.MovieAdapter.GetMovieDetail)
	})

}
