package repository

import (
	"context"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"go.uber.org/zap"
)

type MovieRepository struct {
	db     database.DBExecutor
	logger *zap.Logger
}

func NewMovieRepository(db database.DBExecutor, logger *zap.Logger) *MovieRepository {
	return &MovieRepository{
		db:     db,
		logger: logger,
	}
}

// Movie Detail
func (mr *MovieRepository) GetMovie(ctx context.Context, id int) (*entity.MovieDetail, error) {
	query := `
	SELECT
		id, title, duration_minutes, synopsis, language, age_rating, poster_url, trailer_url, release_date
	FROM movies
	WHERE id = $1 AND deleted_at IS NULL;`

	var movie = entity.MovieDetail{}
	if err := mr.db.QueryRow(ctx, query, id).Scan(
		&movie.ID, &movie.Title, &movie.Duration, &movie.Synopsis, &movie.Language, &movie.AgeRating, &movie.PosterURL,
		&movie.TrailerURL, &movie.ReleaseDate,
	); err != nil {
		mr.logger.Error("cant scan movie detail", zap.Error(err))
		return nil, err
	}

	return &movie, nil
}

func (mr *MovieRepository) GetRatingStar(ctx context.Context, movieId int) (*entity.MovieDetail, error) {
	query := `
	SELECT
    	COALESCE(ROUND(AVG(rating), 1), 0),
     	COUNT(id)
    FROM movie_reviews
    WHERE movie_id = $1;`

	var rating = entity.MovieDetail{}
	if err := mr.db.QueryRow(ctx, query, movieId).Scan(
		&rating.ReviewStar, &rating.ReviewCount,
	); err != nil {
		mr.logger.Error("cant scan movie rating star", zap.Error(err))
		return nil, err
	}

	return &rating, nil
}

func (mr *MovieRepository) GetMovieGenres(ctx context.Context, movieId int) (*[]string, error) {
	query := `
	SELECT g.name
	FROM genres g
		JOIN movie_genres mg ON mg.genre_id = g.id
	WHERE mg.movie_id = $1
	ORDER BY g.name;`

	rows, err := mr.db.Query(ctx, query, movieId)
	if err != nil {
		mr.logger.Error("cant scan movie genre", zap.Error(err))
		return nil, err
	}

	defer rows.Close()

	var genres []string
	for rows.Next() {
		var genre string
		if err := rows.Scan(&genre); err != nil {
			mr.logger.Error("cant scan movie genre", zap.Error(err))
			return nil, err
		}
		genres = append(genres, genre)
	}

	return &genres, nil
}

func (mr *MovieRepository) GetMovieDirector(ctx context.Context, movieId int) (*[]dto.Director, error) {
	query := `
	SELECT p.name, p.avatar_url
	FROM people p
		JOIN movie_people mp ON mp.person_id = p.id
	WHERE mp.movie_id = $1
  		AND mp.role = 'director'
    ORDER BY p.name;`

	rows, err := mr.db.Query(ctx, query, movieId)
	if err != nil {
		mr.logger.Error("cant scan movie people", zap.Error(err))
		return nil, err
	}

	defer rows.Close()
	var directors []dto.Director
	for rows.Next() {
		var director dto.Director
		if err := rows.Scan(&director.Name, &director.AvatarUrl); err != nil {
			mr.logger.Error("cant scan movie director", zap.Error(err))
			return nil, err
		}
		directors = append(directors, director)
	}

	return &directors, nil
}

func (mr *MovieRepository) GetMovieActors(ctx context.Context, movieId int) (*[]dto.Actor, error) {
	query := `
	SELECT p.name, p.avatar_url
	FROM people p
		JOIN movie_people mp ON mp.person_id = p.id
	WHERE mp.movie_id = $1
  		AND mp.role = 'actor'
    ORDER BY p.name;`

	rows, err := mr.db.Query(ctx, query, movieId)
	if err != nil {
		mr.logger.Error("cant scan movie people", zap.Error(err))
		return nil, err
	}

	defer rows.Close()

	var actors []dto.Actor
	for rows.Next() {
		var actor dto.Actor
		if err := rows.Scan(&actor.Name, &actor.AvatarUrl); err != nil {
			mr.logger.Error("cant scan movie people", zap.Error(err))
			return nil, err
		}
		actors = append(actors, actor)
	}

	return &actors, nil
}

// List Movie
func (mr *MovieRepository) GetMoviesNowShowing(ctx context.Context, page, limit int) (*[]entity.ListMovies, int, error) {
	offset := (page - 1) * limit

	// get total data for pagination
	var total int
	countQuery := `
	SELECT COUNT(*) FROM movies
	WHERE release_date <= CURRENT_DATE
		AND (end_date IS NULL OR end_date >= CURRENT_DATE)
		AND deleted_at IS NULL;`
	err := mr.db.QueryRow(ctx, countQuery).Scan(&total)
	if err != nil {
		mr.logger.Error("error query getAll repo ", zap.Error(err))
		return nil, 0, err
	}

	query := `
	SELECT
		id, title, duration_minutes, poster_url
	FROM movies
	WHERE release_date <= CURRENT_DATE
		AND (end_date IS NULL OR end_date >= CURRENT_DATE)
		AND deleted_at IS NULL
	ORDER BY release_date ASC
	LIMIT $1 OFFSET $2;`

	rows, err := mr.db.Query(ctx, query, limit, offset)
	if err != nil {
		mr.logger.Error("cant get movies", zap.Error(err))
		return nil, 0, err
	}
	defer rows.Close()

	var movies []entity.ListMovies
	for rows.Next() {
		var movie entity.ListMovies
		if err := rows.Scan(&movie.ID, &movie.Title, &movie.Duration, &movie.PosterURL); err != nil {
			mr.logger.Error("cant scan movies", zap.Error(err))
			return nil, 0, err
		}
		movies = append(movies, movie)
	}

	return &movies, total, nil
}

func (mr *MovieRepository) GetMoviesComingSoon(ctx context.Context, page, limit int) (*[]entity.ListMovies, int, error) {
	offset := (page - 1) * limit

	// get total data for pagination
	var total int
	countQuery := `
	SELECT COUNT(*) FROM movies
	WHERE release_date > CURRENT_DATE
		AND (end_date IS NULL OR end_date >= CURRENT_DATE)
		AND deleted_at IS NULL;`
	err := mr.db.QueryRow(ctx, countQuery).Scan(&total)
	if err != nil {
		mr.logger.Error("error query getAll repo ", zap.Error(err))
		return nil, 0, err
	}

	query := `
	SELECT
		id, title, duration_minutes, poster_url
	FROM movies
	WHERE release_date > CURRENT_DATE
		AND (end_date IS NULL OR end_date >= CURRENT_DATE)
		AND deleted_at IS NULL
	ORDER BY id ASC
	LIMIT $1 OFFSET $2;`

	rows, err := mr.db.Query(ctx, query, limit, offset)
	if err != nil {
		mr.logger.Error("cant get movies", zap.Error(err))
		return nil, 0, err
	}
	defer rows.Close()

	var movies []entity.ListMovies
	for rows.Next() {
		var movie entity.ListMovies
		if err := rows.Scan(&movie.ID, &movie.Title, &movie.Duration, &movie.PosterURL); err != nil {
			mr.logger.Error("cant scan movies", zap.Error(err))
			return nil, 0, err
		}
		movies = append(movies, movie)
	}

	return &movies, total, nil
}

func (mr *MovieRepository) GetRatingStarAllMovies(ctx context.Context, movieIds []int) (*[]entity.ListMovies, error) {
	query := `
	SELECT
    	COALESCE(ROUND(AVG(rating), 1), 0),
     	COUNT(id)
    FROM movie_reviews
    WHERE movie_id = ANY($1)
    GROUP BY movie_id;`

	rows, err := mr.db.Query(ctx, query, movieIds)
	if err != nil {
		mr.logger.Error("cant get movies rating", zap.Error(err))
		return nil, err
	}

	defer rows.Close()
	var ratings = []entity.ListMovies{}
	for rows.Next() {
		var rating entity.ListMovies
		if err := rows.Scan(&rating.ReviewStar, &rating.ReviewCount); err != nil {
			mr.logger.Error("cant scan movies rating", zap.Error(err))
			return nil, err
		}
		ratings = append(ratings, rating)
	}

	return &ratings, nil
}

func (mr *MovieRepository) GetGenresAllMovies(ctx context.Context, movieId []int) (*[][]string, error) {
	query := `
	SELECT
    	ARRAY_AGG(g.name ORDER BY g.name)
    FROM movie_genres mg
    	JOIN genres g ON g.id = mg.genre_id
    WHERE mg.movie_id = ANY($1)
    GROUP BY mg.movie_id;`

	rows, err := mr.db.Query(ctx, query, movieId)
	if err != nil {
		mr.logger.Error("cant scan movie genre", zap.Error(err))
		return nil, err
	}

	defer rows.Close()

	var genres [][]string
	for rows.Next() {
		var genre []string
		if err := rows.Scan(&genre); err != nil {
			mr.logger.Error("cant scan movie genre", zap.Error(err))
			return nil, err
		}
		genres = append(genres, genre)
	}

	return &genres, nil
}

func (mr *MovieRepository) GetDirectorsAllMovies(ctx context.Context, movieId []int) (*[][]string, error) {
	query := `
	SELECT
		ARRAY_AGG(p.name ORDER BY p.name)
	FROM people p
		JOIN movie_people mp ON mp.person_id = p.id
	WHERE mp.movie_id = ANY($1)
  		AND mp.role = 'director'
    GROUP BY mp.movie_id;`

	rows, err := mr.db.Query(ctx, query, movieId)
	if err != nil {
		mr.logger.Error("cant scan movie people", zap.Error(err))
		return nil, err
	}

	defer rows.Close()

	var people [][]string
	for rows.Next() {
		var person []string
		if err := rows.Scan(&person); err != nil {
			mr.logger.Error("cant scan movie people", zap.Error(err))
			return nil, err
		}
		people = append(people, person)
	}

	return &people, nil
}

func (mr *MovieRepository) GetActorsAllMovies(ctx context.Context, movieId []int) (*[][]string, error) {
	query := `
	SELECT
		ARRAY_AGG(p.name ORDER BY p.name)
	FROM people p
		JOIN movie_people mp ON mp.person_id = p.id
	WHERE mp.movie_id = ANY($1)
  		AND mp.role = 'actor'
    GROUP BY mp.movie_id;`

	rows, err := mr.db.Query(ctx, query, movieId)
	if err != nil {
		mr.logger.Error("cant scan movie people", zap.Error(err))
		return nil, err
	}

	defer rows.Close()

	var people [][]string
	for rows.Next() {
		var person []string
		if err := rows.Scan(&person); err != nil {
			mr.logger.Error("cant scan movie people", zap.Error(err))
			return nil, err
		}
		people = append(people, person)
	}

	return &people, nil
}
