package entity

import "time"

type Model struct {
	ID         int
	Name       int
	Created_At time.Time
	Updated_At time.Time
	Deleted_At time.Time
}
