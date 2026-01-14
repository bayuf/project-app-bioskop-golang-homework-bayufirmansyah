package entity

import (
	"time"
)

type MovieDetail struct {
	ID          int
	Title       string
	Duration    int
	ReviewStar  float64
	ReviewCount int
	Genres      []string
	Rating      string
	Synopsis    string
	Language    string
	AgeRating   string
	PosterURL   string
	TrailerURL  string
	Directors   []string
	Actors      []string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

type ListMovies struct {
	ID          int
	Title       string
	Duration    int
	ReviewStar  float64
	ReviewCount int
	Genres      []string
	PosterURL   string
	Category    string //"now playing" "coming soon"
}
