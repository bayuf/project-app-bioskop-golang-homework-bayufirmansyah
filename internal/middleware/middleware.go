package middleware

import (
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"go.uber.org/zap"
)

type Middleware struct {
	AuthMiddleware *AuthMiddleware
}

func NewCustomMiddleware(repo *repository.Repository, log *zap.Logger) *Middleware {
	return &Middleware{
		AuthMiddleware: NewAuthMiddleware(repo.AuthRepository, log),
	}
}
