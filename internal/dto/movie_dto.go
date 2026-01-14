package dto

type MovieDetail struct {
	ID          int        `json:"id"`
	Title       string     `json:"title"`
	Duration    int        `json:"duration"`
	ReviewStar  float64    `json:"rating"`
	ReviewCount int        `json:"review_count"`
	Genres      []string   `json:"genre"`
	Synopsis    string     `json:"story"`
	Language    string     `json:"language"`
	AgeRating   string     `json:"age_rating"`
	PosterURL   string     `json:"poster_url"`
	TrailerURL  string     `json:"trailer_url"`
	Directors   []Director `json:"directors"`
	Actors      []Actor    `json:"actors"`
}

type ListMovies struct {
	ID          int      `json:"id"`
	Title       string   `json:"title"`
	Duration    int      `json:"duration"`
	ReviewStar  float64  `json:"rating"`
	ReviewCount int      `json:"review_count"`
	Genres      []string `json:"genre"`
	PosterURL   string   `json:"poster_url"`
	Category    string   `json:"category"`
}

type Director struct {
	Name      string `json:"director_name"`
	AvatarUrl string `json:"director_avatar_url"`
}

type Actor struct {
	Name      string `json:"actor_name"`
	AvatarUrl string `json:"actor_avatar_url"`
}
