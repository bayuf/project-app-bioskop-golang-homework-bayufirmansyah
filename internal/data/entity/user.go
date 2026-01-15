package entity

type User struct {
	Model
	Email    string
	Password string
	IsActive bool
}
