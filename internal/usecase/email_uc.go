package usecase

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

type EmailUsecase struct {
	logger *zap.Logger
	config *utils.Configuration
}

func NewEmailUsecase(logger *zap.Logger, config *utils.Configuration) *EmailUsecase {
	return &EmailUsecase{
		logger: logger,
		config: config,
	}
}

func (uc *EmailUsecase) SendEmail(payload *dto.Email) error {
	body, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal email payload: %w", err)
	}

	req, err := http.NewRequest("POST", uc.config.API_URL, bytes.NewBuffer(body))
	if err != nil {
		return fmt.Errorf("failed to create HTTP request: %w", err)
	}

	// setup header
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("x-api-key", uc.config.API_KEY)

	// request to api
	httpClient := &http.Client{Timeout: time.Second * 5}

	response, err := httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to send email: %w", err)
	}
	defer response.Body.Close()

	// handle response api
	var result map[string]any
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		return fmt.Errorf("failed to decode response body: %w", err)
	}

	uc.logger.Info("send email", zap.Any("result", result))
	return nil
}
