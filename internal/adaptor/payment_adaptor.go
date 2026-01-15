package adaptor

import (
	"net/http"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

type PaymentAdaptor struct {
	usecase *usecase.PaymentUseCase
	logger  *zap.Logger
	config  *utils.Configuration
}

func NewPaymentAdaptor(usecase *usecase.PaymentUseCase, logger *zap.Logger, config *utils.Configuration) *PaymentAdaptor {
	return &PaymentAdaptor{
		usecase: usecase,
		logger:  logger,
		config:  config,
	}
}

func (ad *PaymentAdaptor) GetPaymentMethods(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	if r.Method != "GET" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "failed", nil)
		return
	}

	data, err := ad.usecase.GetPaymentMethods(ctx)
	if err != nil {
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed", err)
		return
	}

	utils.ResponseSuccess(w, http.StatusOK, "success", data)
}
