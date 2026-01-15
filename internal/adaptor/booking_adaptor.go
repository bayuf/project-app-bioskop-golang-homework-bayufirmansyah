package adaptor

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/middleware"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
	"golang.org/x/sync/errgroup"
)

type BookingAdaptor struct {
	usecase *usecase.BookingUseCase
	logger  *zap.Logger
	config  *utils.Configuration
}

func NewBookingAdaptor(usecase *usecase.BookingUseCase, logger *zap.Logger, config *utils.Configuration) *BookingAdaptor {
	return &BookingAdaptor{
		usecase: usecase,
		logger:  logger,
		config:  config,
	}
}

func (ad *BookingAdaptor) BookingSeat(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if r.Method != "POST" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "failed", nil)
		return
	}

	// get from contex
	user, ok := middleware.GetAuthUser(r)
	if !ok {
		utils.ResponseFailed(w, http.StatusUnauthorized, "unauthorized", nil)
		return
	}

	newBooking := dto.BookingReqBody{}
	if err := json.NewDecoder(r.Body).Decode(&newBooking); err != nil {
		utils.ResponseFailed(w, http.StatusBadRequest, "invalid input format", err.Error())
		return
	}

	// validate input
	messageInvalid, err := utils.ValidateInput(&newBooking)
	if err != nil {
		utils.ResponseFailed(w, http.StatusBadRequest, "invalid input data", messageInvalid)
		return
	}

	var (
		date      time.Time
		timeClock time.Time
	)

	g, _ := errgroup.WithContext(ctx)

	g.Go(func() error {
		var err error
		dateStr := newBooking.Date
		date, err = time.Parse("2006-01-02", dateStr)
		if err != nil {
			ad.logger.Error("failed to parse date string", zap.Error(err))
			return err
		}
		return nil
	})

	g.Go(func() error {
		var err error
		timeStr := newBooking.Time
		timeClock, err = time.Parse("15:04:05", timeStr)
		if err != nil {
			ad.logger.Error("failed to parse time string", zap.Error(err))
			return err
		}
		return nil
	})

	// wait for parsing result
	if err := g.Wait(); err != nil {
		utils.ResponseFailed(w, http.StatusBadRequest, "failed parse", err.Error())
		return
	}

	newBookingReq := dto.BookingReq{
		CinemaID: newBooking.CinemaID,
		SeatID:   newBooking.SeatID,
		Date:     date,
		Time:     timeClock,
	}

	order, err := ad.usecase.BookingSeat(ctx, user.UserID, newBookingReq)
	if err != nil {
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed", err.Error())
		return
	}

	utils.ResponseSuccess(w, http.StatusCreated, "success", order)
}

func (ad *BookingAdaptor) GetBookingHistory(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if r.Method != "GET" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "method not allowed", nil)
		return
	}

	// get from contex
	user, ok := middleware.GetAuthUser(r)
	if !ok {
		utils.ResponseFailed(w, http.StatusUnauthorized, "unauthorized", nil)
		return
	}

	bookings, err := ad.usecase.GetBookingHistory(ctx, user.UserID)
	if err != nil {
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed", err.Error())
		return
	}

	utils.ResponseSuccess(w, http.StatusOK, "success", bookings)
}
