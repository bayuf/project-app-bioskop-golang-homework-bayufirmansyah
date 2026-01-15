package entity

import (
	"time"

	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

type Booking struct {
	ID         uuid.UUID
	UserID     uuid.UUID
	ScheduleID uuid.UUID
	Status     string
	TotalPrice decimal.Decimal
	CreatedAt  time.Time
	UpdatedAt  time.Time
}

type BookingSeat struct {
	BookingID     uuid.UUID
	ScheduleID    uuid.UUID
	SeatID        uuid.UUID
	BookingStatus string
}
