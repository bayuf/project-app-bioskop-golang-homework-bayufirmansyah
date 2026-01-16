package dto

import (
	"time"

	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

type BookingReqBody struct {
	CinemaID int    `json:"cinema_id" validate:"required"`
	SeatID   int    `json:"seat_id" validate:"required"`
	Date     string `json:"date" validate:"required"`
	Time     string `json:"time" validate:"required"`
}

type BookingReq struct {
	CinemaID int       `json:"cinema_id" validate:"required"`
	SeatID   int       `json:"seat_id" validate:"required"`
	Date     time.Time `json:"date" validate:"required"`
	Time     time.Time `json:"time" validate:"required"`
}

type Booking struct {
	ID         uuid.UUID       `json:"order_id"`
	UserID     uuid.UUID       `json:"user_id,omitempty"`
	ScheduleID uuid.UUID       `json:"schedule_id,omitempty"`
	Status     string          `json:"status,omitempty"`
	TotalPrice decimal.Decimal `json:"total_price"`
	CreatedAt  time.Time       `json:"created_at"`
	UpdatedAt  time.Time       `json:"updated_at"`
}

type BookingRes struct {
	ID         uuid.UUID       `json:"booking_id"`
	Status     string          `json:"status,omitempty"`
	TotalPrice decimal.Decimal `json:"total_price"`
}
type BookingSeat struct {
	BookingID     uuid.UUID `json:"booking_id"`
	ScheduleID    uuid.UUID `json:"schedule_id"`
	SeatID        uuid.UUID `json:"seat_id"`
	BookingStatus string    `json:"booking_status"`
}

type BookingHystory struct {
	Title          string    `json:"title"`
	PosterUrl      string    `json:"poster_url"`
	Duration       int       `json:"duration"`
	Date           time.Time `json:"date"`
	CinemaName     string    `json:"cinema_name"`
	CinemaLocation string    `json:"cinema_location"`
	StudioName     string    `json:"studio_name"`
}

type BookingDetail struct {
	ID             uuid.UUID       `json:"order_id"`
	Title          string          `json:"title"`
	PosterUrl      string          `json:"poster_url"`
	Duration       int             `json:"duration"`
	Date           time.Time       `json:"date"`
	Time           time.Time       `json:"time"`
	CinemaName     string          `json:"cinema_name"`
	CinemaLocation string          `json:"cinema_location"`
	StudioName     string          `json:"studio_name"`
	Seat           string          `json:"seat"`
	TotalAmount    decimal.Decimal `json:"total_amount"`
}
