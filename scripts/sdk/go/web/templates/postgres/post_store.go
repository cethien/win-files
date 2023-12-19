package postgres

import (
	"database/sql"

	"github.com/cethien/go-web-template/domain"
)

type PostStore struct {
	*sql.DB
}

func (s *PostStore) Create(u *domain.Post) error {
	panic("not implemented") // TODO: Implement
}

func (s *PostStore) GetMany() ([]*domain.Post, error) {
	panic("not implemented") // TODO: Implement
}

func (s *PostStore) Get(id int) (*domain.Post, error) {
	panic("not implemented") // TODO: Implement
}

func (s *PostStore) Update(u *domain.Post) error {
	panic("not implemented") // TODO: Implement
}

func (s *PostStore) Delete(u *domain.Post) error {
	panic("not implemented") // TODO: Implement
}
