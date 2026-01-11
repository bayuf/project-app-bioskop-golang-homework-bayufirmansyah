package dto

import (
	"time"

	"github.com/google/uuid"
)

type Session struct {
	Token     uuid.UUID `json:"token"`
	UserID    uuid.UUID `json:"user_id"`
	ExpiresAt time.Time `json:"expires_at"`
	CreatedAt time.Time `json:"created_at"`
}
