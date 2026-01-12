package adaptor

import (
	"encoding/json"
	"net/http"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/usecase"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"go.uber.org/zap"
)

type AuthAdaptor struct {
	uc     *usecase.AuthUsecase
	logger *zap.Logger
	config *utils.Configuration
}

func NewAuthAdaptor(uc *usecase.AuthUsecase, logger *zap.Logger, config *utils.Configuration) *AuthAdaptor {
	return &AuthAdaptor{
		uc:     uc,
		logger: logger,
		config: config,
	}
}

func (a *AuthAdaptor) RegisterUser(w http.ResponseWriter, r *http.Request) {
	newUser := dto.UserRegister{}
	if r.Method != "POST" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "method not allowed", nil)
		return
	}

	if err := json.NewDecoder(r.Body).Decode(&newUser); err != nil {
		utils.ResponseFailed(w, http.StatusBadRequest, "invalid input format", err)
		return
	}

	// validate
	messageInvalid, err := utils.ValidateInput(&newUser)
	if err != nil {
		utils.ResponseFailed(w, http.StatusBadRequest, "invalid input data", messageInvalid)
		return
	}

	if err := a.uc.RegisterUser(r.Context(), newUser); err != nil {
		a.logger.Error("failed to create new user", zap.Error(err))
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed to create new user", err)
		return
	}

	utils.ResponseSuccess(w, http.StatusCreated, "success", nil)
}

func (a *AuthAdaptor) LoginUser(w http.ResponseWriter, r *http.Request) {
	newUser := dto.UserLogin{}
	if r.Method != "POST" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "method not allowed", nil)
		return
	}

	if err := json.NewDecoder(r.Body).Decode(&newUser); err != nil {
		utils.ResponseFailed(w, http.StatusBadRequest, "invalid input format", err)
		return
	}

	// validate
	messageInvalid, err := utils.ValidateInput(&newUser)
	if err != nil {
		utils.ResponseFailed(w, http.StatusBadRequest, "invalid input data", messageInvalid)
		return
	}

	if err := a.uc.LoginUser(r.Context(), newUser); err != nil {
		a.logger.Error("failed to create new user", zap.Error(err))
		utils.ResponseFailed(w, http.StatusInternalServerError, "failed to create new user", err)
		return
	}

	utils.ResponseSuccess(w, http.StatusCreated, "success", nil)
}

func (a *AuthAdaptor) LogoutUser(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		utils.ResponseFailed(w, http.StatusMethodNotAllowed, "method not allowed", nil)
		return
	}

	utils.ResponseSuccess(w, http.StatusCreated, "success", nil)
}
