package repository

import (
	"context"
	"errors"

	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/internal/data/entity"
	"github.com/bayuf/project-app-bioskop-golang-homework-bayufirmansyah/pkg/database"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

type AuthRepository struct {
	db     database.DBExecutor
	logger *zap.Logger
}

func NewAuthRepository(db database.DBExecutor, logger *zap.Logger) *AuthRepository {
	return &AuthRepository{
		db:     db,
		logger: logger,
	}
}

func (ar *AuthRepository) RegisterUser(ctx context.Context, newUser entity.User) error {
	ar.logger.Info("Registering user", zap.String("email", newUser.Email))

	query := `INSERT INTO users (id, email, name, password_hash) VALUES ($1, $2, $3, $4)`

	commandTag, err := ar.db.Exec(ctx, query, newUser.Model.ID, newUser.Email, newUser.Name, newUser.Password)
	if err != nil {
		if commandTag.RowsAffected() == 0 {
			ar.logger.Error("Failed to register user", zap.Error(err))
			return errors.New("Failed to register user")
		}
		ar.logger.Error("Failed to register user", zap.Error(err))
		return err
	}

	ar.logger.Info("User registered successfully", zap.String("email", newUser.Email))
	return nil
}

func (ar *AuthRepository) UpdateUserStatus(ctx context.Context, userID uuid.UUID) error {
	query := `
	UPDATE users
		SET is_active = TRUE
	WHERE id = $1
		AND is_active = FALSE
		AND deleted_at IS NULL;`

	if _, err := ar.db.Exec(ctx, query, userID); err != nil {
		ar.logger.Error("Failed to update user status", zap.Error(err))
		return err
	}

	ar.logger.Info("User status updated successfully", zap.String("user_id", userID.String()))
	return nil
}

func (ar *AuthRepository) FindUserByEmail(ctx context.Context, email string) (*entity.User, error) {
	query := `
	SELECT
		id, email, name, password_hash, created_at, updated_at
	FROM users
	WHERE email = $1
		AND deleted_at IS NULL;
	`
	user := entity.User{}
	if err := ar.db.QueryRow(ctx, query, email).
		Scan(&user.Model.ID, &user.Email, &user.Model.Name, &user.Password, &user.Created_At, &user.Updated_At); err != nil {
		ar.logger.Error("Failed to find user by email", zap.Error(err))
		return nil, err
	}

	return &user, nil
}

func (ar *AuthRepository) CreateSession(ctx context.Context, newSession entity.Session) error {
	query := `
	INSERT INTO sessions (token, user_id, expired_at)
	VALUES ($1, $2, $3)
	`
	commandTag, err := ar.db.Exec(ctx, query, newSession.ID, newSession.UserID, newSession.ExpiresAt)
	if err != nil {
		if commandTag.RowsAffected() == 0 {
			ar.logger.Error("Failed to create session", zap.Error(err))
			return errors.New("failed to create session")
		}

		ar.logger.Error("Failed to create session", zap.Error(err))
		return err
	}

	return nil
}

func (ar *AuthRepository) GetSessionIdByUserId(ctx context.Context, userId uuid.UUID) (*entity.Session, error) {
	query := `
	SELECT
		token, user_id, expired_at, created_at
	FROM sessions
	WHERE user_id = $1
		AND revoked_at IS NULL
		AND expired_at > NOW();
	`
	session := entity.Session{}
	if err := ar.db.QueryRow(ctx, query, userId).
		Scan(&session.ID, &session.UserID, &session.ExpiresAt, &session.CreatedAt); err != nil {
		ar.logger.Error("Failed to find session by user ID", zap.Error(err))
		return nil, err
	}

	return &session, nil
}

func (ar *AuthRepository) ValidateSession(ctx context.Context, sessionId uuid.UUID) (*entity.Session, error) {
	query := `SELECT s.token, s.user_id
			FROM sessions s
			WHERE s.token = $1
			  AND s.revoked_at IS NULL
			  AND s.expired_at > NOW();`
	session := entity.Session{}
	if err := ar.db.QueryRow(ctx, query, sessionId).Scan(
		&session.ID,
		&session.UserID,
	); err != nil {
		ar.logger.Error("error validate session", zap.Error(err))
		return nil, err
	}
	return &session, nil
}

func (ar *AuthRepository) RevokeSessionByUserId(ctx context.Context, userId uuid.UUID) error {
	query := `
	UPDATE sessions
	SET revoked_at = NOW()
	WHERE user_id = $1 AND
	revoked_at IS NULL AND
	expired_at < NOW();
	`
	_, err := ar.db.Exec(ctx, query, userId)
	if err != nil {
		ar.logger.Error("Failed to revoke session", zap.Error(err))
		return err
	}

	ar.logger.Info("Session revoked successfully")
	return nil
}

func (ar *AuthRepository) RevokeSessionBySessionId(ctx context.Context, sessionId uuid.UUID) error {
	query := `
	UPDATE sessions
	SET revoked_at = NOW()
	WHERE id = $1 AND
	revoked_at IS NULL AND
	expired_at < NOW();
	`
	_, err := ar.db.Exec(ctx, query, sessionId)
	if err != nil {
		ar.logger.Error("Failed to revoke session", zap.Error(err))
		return err
	}

	ar.logger.Info("Session revoked successfully")
	return nil
}

func (ar *AuthRepository) AddVerificationCode(ctx context.Context, data entity.VerificationCode) error {
	query := `
	INSERT INTO verification_codes (id, user_id, code_hash, purpose, expired_at)
	VALUES ($1, $2, $3, $4, $5)
	`
	commandTag, err := ar.db.Exec(ctx, query, data.ID, data.UserID, data.Code, data.Purpose, data.ExpiredAt)
	if err != nil {
		if commandTag.RowsAffected() == 0 {
			ar.logger.Error("Failed to add verification code", zap.Error(err))
			return errors.New("failed to add verification code")
		}

		ar.logger.Error("Failed to add verification code", zap.Error(err))
		return err
	}

	ar.logger.Info("Verification code added successfully")
	return nil
}

func (ar *AuthRepository) GetVerifyCodeByUserId(ctx context.Context, userId uuid.UUID) (*entity.VerificationCode, error) {
	query := `
	SELECT id, user_id, code_hash, purpose
	FROM verification_codes
	WHERE user_id = $1 AND
	used_at IS NULL AND
	expired_at > NOW();
	`
	code := entity.VerificationCode{}
	if err := ar.db.QueryRow(ctx, query, userId).
		Scan(&code.ID, &code.UserID, &code.Code, &code.Purpose); err != nil {
		ar.logger.Error("Failed to find verification code by user ID", zap.Error(err))
		return nil, err
	}

	return &code, nil
}

func (ar *AuthRepository) UpdateVerificationCodeStatus(ctx context.Context, ID uuid.UUID) error {
	query := `
	UPDATE verification_codes
	SET used_at = NOW()
	WHERE id = $1
		AND	used_at IS NULL
		AND expired_at > NOW();
	`

	commandTag, err := ar.db.Exec(ctx, query, ID)
	if err != nil {
		if commandTag.RowsAffected() == 0 {
			ar.logger.Error("Failed to update verification code status", zap.Error(err))
			return errors.New("failed to update verification code status")
		}

		ar.logger.Error("Failed to update verification code status", zap.Error(err))
		return err
	}

	return nil
}
