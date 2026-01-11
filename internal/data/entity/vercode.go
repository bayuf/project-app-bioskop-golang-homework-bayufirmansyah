package entity

import (
	"time"

	"github.com/google/uuid"
)

type VerificationCode struct {
	ID        uuid.UUID
	UserID    uuid.UUID
	Code      string
	Purpose   string
	ExpiredAt time.Time
	UsedAt    time.Time
	CreatedAt time.Time
}
