package usecase

import (
	"context"
	"errors"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

type AuthUsecase struct {
	repo   *repository.AuthRepository
	logger *zap.Logger
}

func NewAuthUsecase(repo *repository.AuthRepository, logger *zap.Logger) *AuthUsecase {
	return &AuthUsecase{
		repo:   repo,
		logger: logger,
	}
}

func (uc *AuthUsecase) RegisterUser(ctx context.Context, userData dto.UserRegister) error {

	hashPass, err := utils.HashString(userData.Password)
	if err != nil {
		uc.logger.Error("failed to hash password", zap.Error(err))
		return err
	}
	return uc.repo.RegisterUser(ctx, entity.User{
		Model: entity.Model{
			ID:   uuid.New(),
			Name: userData.Name},
		Email:    userData.Email,
		Password: hashPass,
	})
}

func (uc *AuthUsecase) LoginUser(ctx context.Context, userData dto.UserLogin) error {

	// get user by email
	user, err := uc.repo.FindUserByEmail(ctx, userData.Email)
	if err != nil {
		uc.logger.Error("invalid credentials", zap.Error(err))
		return err
	}

	// check password
	if !utils.CheckString(userData.Password, user.Password) {
		uc.logger.Error("invalid credentials")
		return err
	}

	// generate codeOTP
	code, err := utils.GenerateOTP()
	if err != nil {
		uc.logger.Error("failed to generate verify code", zap.Error(err))
		return err
	}

	// hash codeOTP
	hashedCode, err := utils.HashString(code)
	if err != nil {
		uc.logger.Error("failed to hash verify code", zap.Error(err))
		return err
	}

	// add verification code to db
	if err := uc.repo.AddVerificationCode(ctx, entity.VerificationCode{
		ID:        uuid.New(),
		UserID:    user.Model.ID,
		Code:      hashedCode,
		Purpose:   "login",
		ExpiredAt: time.Now().Add(5 * time.Minute),
	}); err != nil {
		return err
	}

	// send OTP via email

	return nil
}

func (uc *AuthUsecase) VerifyCode(ctx context.Context, userId uuid.UUID) (*dto.Session, error) {
	data, err := uc.repo.GetVerifyCodeByUserId(ctx, userId)
	if err != nil {
		return nil, err
	}

	// check if code is expired
	if data.ExpiredAt.Before(time.Now()) {
		return nil, errors.New("code expired")
	}

	// create new session
	if err := uc.repo.CreateSession(ctx, entity.Session{
		ID:        uuid.New(),
		UserID:    userId,
		ExpiresAt: time.Now().Add(24 * time.Hour),
	}); err != nil {
		return nil, err
	}

	// get session data
	session, err := uc.repo.GetSessionIdByUserId(ctx, userId)
	if err != nil {
		return nil, err
	}

	return &dto.Session{
		Token:     session.ID,
		UserID:    session.UserID,
		ExpiresAt: session.ExpiresAt,
		CreatedAt: session.CreatedAt,
	}, nil
}
