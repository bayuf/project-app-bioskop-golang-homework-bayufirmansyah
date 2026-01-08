package repository

import (
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"go.uber.org/zap"
)

type Repository struct {
}

func NewRepository(db database.DBExecutor, log *zap.Logger) *Repository {
	return &Repository{}
}
