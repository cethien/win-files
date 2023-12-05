package domain

type User struct {
	Id        int
	FirstName string
	LastName  string
	EMail     string
	Posts     []Post
}

type UserStore interface {
	Create(u *User) error
	GetMany() ([]*User, error)
	Get(id int) (*User, error)
	Update(u *User) error
	Delete(u *User) error
}
