package domain

type Post struct {
	Id      int
	Title   string
	Content string
	Author  User
}

type PostStore interface {
	Create(u *User) error
	GetMany() ([]*User, error)
	Get(id int) (*User, error)
	Update(u *User) error
	Delete(u *User) error
}
