package repository

import (
	"context"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"go.uber.org/zap"
)

type PaymentRepository struct {
	db     database.DBExecutor
	logger *zap.Logger
}

func NewPaymentRepository(db database.DBExecutor, logger *zap.Logger) *PaymentRepository {
	return &PaymentRepository{
		db:     db,
		logger: logger,
	}
}

func (pr *PaymentRepository) GetPaymentMethods(ctx context.Context) (*[]dto.PaymentRes, error) {
	query := `
	SELECT
		id, name, logo
	FROM payment_methods
	WHERE deleted_at IS NULL;`

	rows, err := pr.db.Query(ctx, query)
	if err != nil {
		pr.logger.Error("failed to query payment methods", zap.Error(err))
		return nil, err
	}
	defer rows.Close()

	var paymentMethods []dto.PaymentRes
	for rows.Next() {
		var paymentMethod dto.PaymentRes
		if err := rows.Scan(&paymentMethod.ID, &paymentMethod.Name, &paymentMethod.LogoURL); err != nil {
			pr.logger.Error("failed to scan payment method", zap.Error(err))
			return nil, err
		}
		paymentMethods = append(paymentMethods, paymentMethod)
	}

	return &paymentMethods, nil
}
