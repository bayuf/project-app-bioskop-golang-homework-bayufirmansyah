package entity

import (
	"time"

	"github.com/google/uuid"
)

type Cinema struct {
	ID        int       `json:"id" db:"id"`
	Name      string    `json:"name" db:"name"`
	Location  string    `json:"location" db:"location"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
	DeletedAt time.Time `json:"deleted_at" db:"deleted_at"`
}

type CinemaSchedule struct {
	ID        uuid.UUID
	CinemaID  int
	MovieID   int
	StudioID  int
	ShowDate  time.Time
	ShowTime  time.Time
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt time.Time
}
