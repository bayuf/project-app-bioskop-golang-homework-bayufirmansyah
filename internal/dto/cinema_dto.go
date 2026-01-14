package dto

import "time"

type CinemaDetail struct {
	ID        int       `json:"id"`
	Name      string    `json:"name"`
	Location  string    `json:"location"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type CinemaListResponse struct {
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Location string `json:"location"`
}

type SeatStatus struct {
	SeatID   int    `json:"seat_id"`
	SeatCode string `json:"seat_code"`
	Status   string `json:"status"`
}
