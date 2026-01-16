package dto

import (
	"github.com/google/uuid"
)

type PaymentRes struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	LogoURL string `json:"logo_url"`
}

type Payment struct {
	BookingID     uuid.UUID `json:"booking_id" validate:"required"`
	PaymentMethod int       `json:"payment_method" validate:"required"`
}
