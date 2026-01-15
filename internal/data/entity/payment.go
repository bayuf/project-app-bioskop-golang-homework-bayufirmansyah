package entity

import (
	"time"

	"github.com/google/uuid"
	"github.com/shopspring/decimal"
)

type Payment struct {
	ID            uuid.UUID
	BookingID     uuid.UUID
	PaymentMethod int
	Amount        decimal.Decimal
	Status        string
	PaidAt        time.Time
	CreatedAt     time.Time
}
