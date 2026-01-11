package entity

import (
	"time"

	"github.com/google/uuid"
)

type Model struct {
	ID         uuid.UUID `json:"id"`
	Name       string    `json:"name"`
	Created_At time.Time `json:"created_at"`
	Updated_At time.Time `json:"updated_at"`
	Deleted_At time.Time `json:"deleted_at"`
}
