package domain

type Post struct {
	Id      int
	Title   string
	Content string
	Author  User
}

type PostStore interface {
	Create(u *Post) error
	GetMany() ([]*Post, error)
	Get(id int) (*Post, error)
	Update(u *Post) error
	Delete(u *Post) error
}
