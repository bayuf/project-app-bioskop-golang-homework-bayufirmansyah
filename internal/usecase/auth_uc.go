package usecase

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/repository"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/dto"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/utils"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

type AuthUsecase struct {
	repo     *repository.AuthRepository
	logger   *zap.Logger
	config   *utils.Configuration
	tx       database.TxManager
	emailJob chan<- utils.EmailJob
}

func NewAuthUsecase(repo *repository.AuthRepository, logger *zap.Logger, config *utils.Configuration, tx database.TxManager, emailJob chan<- utils.EmailJob) *AuthUsecase {
	return &AuthUsecase{
		repo:     repo,
		logger:   logger,
		config:   config,
		tx:       tx,
		emailJob: emailJob,
	}
}

func (uc *AuthUsecase) RegisterUser(ctx context.Context, userData dto.UserRegister) error {

	hashPass, err := utils.HashString(userData.Password)
	if err != nil {
		uc.logger.Error("failed to hash password", zap.Error(err))
		return err
	}

	tx, err := uc.tx.Begin(ctx)
	if err != nil {
		return err
	}

	defer tx.Rollback(ctx)
	repoTX := repository.NewAuthRepository(tx, uc.logger)

	newUserID := uuid.New()
	verificationID := uuid.New()
	repoTX.RegisterUser(ctx, entity.User{
		Model: entity.Model{
			ID:   newUserID,
			Name: userData.Name},
		Email:    userData.Email,
		Password: hashPass,
	})

	// generate OTP code
	code, err := utils.GenerateOTP()
	if err != nil {
		uc.logger.Error("failed to generate OTP", zap.Error(err))
		return err
	}

	if err := repoTX.AddVerificationCode(ctx, entity.VerificationCode{
		ID:        verificationID,
		UserID:    newUserID,
		Code:      code,
		Purpose:   "register",
		ExpiredAt: time.Now().Add(5 * time.Minute),
	}); err != nil {
		return err
	}

	if err := tx.Commit(ctx); err != nil {
		return err
	}

	return nil
}

func (uc *AuthUsecase) LoginUser(ctx context.Context, userData dto.UserLogin) error {

	// get user by email
	user, err := uc.repo.FindUserByEmail(ctx, userData.Email)
	if err != nil {
		uc.logger.Error("invalid credentials", zap.Error(err))
		return err
	}

	// check password
	if !utils.CheckString(user.Password, userData.Password) {
		uc.logger.Error("invalid credentials")
		return errors.New("invalid credentials")
	}

	// =============================OTP==========================================

	// generate codeOTP
	code, err := utils.GenerateOTP()
	if err != nil {
		uc.logger.Error("failed to generate verify code", zap.Error(err))
		return err
	}

	// hash codeOTP
	// hashedCode, err := utils.HashString(code)
	// if err != nil {
	// 	uc.logger.Error("failed to hash verify code", zap.Error(err))
	// 	return err
	// }

	// add verification code to db
	if err := uc.repo.AddVerificationCode(ctx, entity.VerificationCode{
		ID:        uuid.New(),
		UserID:    user.Model.ID,
		Code:      code,
		Purpose:   "login",
		ExpiredAt: time.Now().Add(5 * time.Minute),
	}); err != nil {
		return err
	}

	// send OTP via email
	payload := &dto.Email{
		To:      user.Email,
		Name:    user.Name,
		Subject: "Login Verification Code",
		Message: fmt.Sprintf("Your login verification code is %s. This code will expire in 5 minutes.", code),
	}

	select {
	case uc.emailJob <- utils.EmailJob{Payload: payload}:
	default:
		uc.logger.Warn("email job queue full, skipping email",
			zap.String("email", user.Email),
		)
	}

	return nil
}

func (uc *AuthUsecase) VerifyCode(ctx context.Context, userReq dto.VerifyCode) (*dto.Session, error) {
	// get user
	user, err := uc.repo.FindUserByEmail(ctx, userReq.Email)
	if err != nil {
		return nil, err
	}

	data, err := uc.repo.GetVerifyCodeByUserId(ctx, user.ID)
	if err != nil {
		return nil, err
	}

	if data.Code != userReq.Code {
		return nil, errors.New("invalid code")
	}
	// check if code is expired
	if !data.ExpiredAt.Before(time.Now()) {
		return nil, errors.New("code expired")
	}

	// update code status as used code
	if err := uc.updateCodeStatus(ctx, data.ID); err != nil {
		return nil, err
	}

	// for register
	if data.Purpose == "register" {
		if err := uc.repo.UpdateUserStatus(ctx, user.ID); err != nil {
			return nil, err
		}
		return nil, nil
	}

	// for login
	// create new session
	if err := uc.repo.CreateSession(ctx, entity.Session{
		ID:        uuid.New(),
		UserID:    user.ID,
		ExpiresAt: time.Now().Add(24 * time.Hour),
	}); err != nil {
		return nil, err
	}

	// get session data
	session, err := uc.repo.GetSessionIdByUserId(ctx, user.ID)
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

func (uc *AuthUsecase) LogoutUser(ctx context.Context, sessionId uuid.UUID) error {
	return uc.repo.RevokeSessionBySessionId(ctx, sessionId)
}

func (uc *AuthUsecase) updateCodeStatus(ctx context.Context, ID uuid.UUID) error {
	return uc.repo.UpdateVerificationCodeStatus(ctx, ID)
}
