package adaptor

import (
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

type Adaptor struct {
	*AuthAdaptor
	*CinemaAdaptor
	*MovieAdapter
	*BookingAdaptor
}

func NewAdaptor(useCase *usecase.UseCase, log *zap.Logger, config *utils.Configuration) *Adaptor {
	return &Adaptor{
		AuthAdaptor:    NewAuthAdaptor(useCase.AuthUsecase, log, config),
		CinemaAdaptor:  NewCinemaAdaptor(useCase.CinemaUseCase, log, config),
		MovieAdapter:   NewMovieAdapter(useCase.MovieUseCase, log, config),
		BookingAdaptor: NewBookingAdaptor(useCase.BookingUseCase, log, config),
	}
}
