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
	ID         uuid.UUID       `json:"id"`
	UserID     uuid.UUID       `json:"user_id"`
	ScheduleID uuid.UUID       `json:"schedule_id"`
	Status     string          `json:"status"`
	TotalPrice decimal.Decimal `json:"total_price"`
	CreatedAt  time.Time       `json:"created_at"`
	UpdatedAt  time.Time       `json:"updated_at"`
}

type BookingSeat struct {
	BookingID     uuid.UUID `json:"booking_id"`
	ScheduleID    uuid.UUID `json:"schedule_id"`
	SeatID        uuid.UUID `json:"seat_id"`
	BookingStatus string    `json:"booking_status"`
}
