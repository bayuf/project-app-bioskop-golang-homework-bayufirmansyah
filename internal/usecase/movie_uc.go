package usecase

import (
	"context"
	"errors"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
	"golang.org/x/sync/errgroup"
)

type MovieUseCase struct {
	repo   *repository.MovieRepository
	logger *zap.Logger
}

func NewMovieUseCase(repo *repository.MovieRepository, logger *zap.Logger) *MovieUseCase {
	return &MovieUseCase{
		repo:   repo,
		logger: logger,
	}
}

func (uc *MovieUseCase) GetMovieDetail(ctx context.Context, movieId int) (*dto.MovieDetail, error) {
	// get movie
	movie, err := uc.repo.GetMovie(ctx, movieId)
	if err != nil {
		return nil, err
	}

	var (
		rating    *entity.MovieDetail
		genres    *[]string
		directors *[]dto.Director
		actors    *[]dto.Actor
	)

	//wait for all goroutines to finish
	g, ctx := errgroup.WithContext(ctx)

	// get rating
	g.Go(func() error {
		var err error
		rating, err = uc.repo.GetRatingStar(ctx, movieId)
		if err != nil {
			return err
		}
		return nil
	})

	// get genres
	g.Go(func() error {
		var err error
		genres, err = uc.repo.GetMovieGenres(ctx, movieId)
		if err != nil {
			return err
		}
		return nil
	})

	// get directors
	g.Go(func() error {
		var err error
		directors, err = uc.repo.GetMovieDirector(ctx, movieId)
		if err != nil {
			return err
		}
		return nil
	})

	// get actors
	g.Go(func() error {
		var err error
		actors, err = uc.repo.GetMovieActors(ctx, movieId)
		if err != nil {
			return err
		}
		return nil
	})

	if err := g.Wait(); err != nil {
		return nil, err
	}

	return &dto.MovieDetail{
		ID:          movie.ID,
		Title:       movie.Title,
		Duration:    movie.Duration,
		Synopsis:    movie.Synopsis,
		Language:    movie.Language,
		ReleaseDate: movie.ReleaseDate,
		AgeRating:   movie.AgeRating,
		PosterURL:   movie.PosterURL,
		TrailerURL:  movie.TrailerURL,
		ReviewStar:  rating.ReviewStar,
		ReviewCount: rating.ReviewCount,
		Genres:      *genres,
		Directors:   *directors,
		Actors:      *actors,
	}, nil
}

func (uc *MovieUseCase) GetMoviesNowShowing(ctx context.Context, page, limit int, category string) (*[]dto.ListMovies, *dto.Pagination, error) {
	var (
		movies  *[]entity.ListMovies
		total   int
		ratings []dto.ListMovies
		genres  [][]string
	)
	switch category {
	case "now_showing":
		// get movie Now Showing
		var err error
		movies, total, err = uc.repo.GetMoviesNowShowing(ctx, page, limit)
		if err != nil {
			return nil, nil, err
		}
	case "coming_soon":
		// get movie Coming Soon
		var err error
		movies, total, err = uc.repo.GetMoviesComingSoon(ctx, page, limit)
		if err != nil {
			return nil, nil, err
		}

	default:
		return nil, nil, errors.New("invalid category")
	}

	// no movies error handling
	if len(*movies) == 0 {
		return nil, nil, errors.New("no movies found")
	}

	pagination := dto.Pagination{
		CurrentPage:  page,
		Limit:        limit,
		TotalPages:   utils.TotalPage(limit, int64(total)),
		TotalRecords: total,
	}

	// get all movieId in movies
	var movieId []int
	for _, v := range *movies {
		temp := v.ID
		movieId = append(movieId, temp)
	}

	// errgroup
	g, ctx := errgroup.WithContext(ctx)

	// get rating
	g.Go(func() error {
		movieRatings, err := uc.repo.GetRatingStarAllMovies(ctx, movieId)
		if err != nil {
			return err
		}

		for _, v := range *movieRatings {
			movie := dto.ListMovies{
				ReviewStar:  v.ReviewStar,
				ReviewCount: v.ReviewCount,
			}
			ratings = append(ratings, movie)
		}
		return nil
	})

	// get genres
	g.Go(func() error {
		genresResponse, err := uc.repo.GetGenresAllMovies(ctx, movieId)
		if err != nil {
			return err
		}

		for _, v := range *genresResponse {
			genres = append(genres, v)
		}
		return nil
	})

	if err := g.Wait(); err != nil {
		return nil, nil, err
	}

	// mapping
	var moviesResponse []dto.ListMovies
	for i, v := range *movies {
		movie := dto.ListMovies{
			ID:          v.ID,
			Title:       v.Title,
			Duration:    v.Duration,
			PosterURL:   v.PosterURL,
			ReviewStar:  ratings[i].ReviewStar,
			ReviewCount: ratings[i].ReviewCount,
			Genres:      genres[i],
			Category:    category,
		}
		moviesResponse = append(moviesResponse, movie)
	}

	return &moviesResponse, &pagination, nil
}
