package entity

import "time"

type PaymentMethod struct {
	ID        int
	Name      string
	LogoURL   string
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time
}
