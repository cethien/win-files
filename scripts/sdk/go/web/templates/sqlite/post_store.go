package sqlite

import "example.com/template/domain"

type PostStore struct {
	*store
}

func (s *PostStore) Create(u *domain.User) error {
	panic("not implemented") // TODO: Implement
}

func (s *PostStore) GetMany() ([]*domain.User, error) {
	panic("not implemented") // TODO: Implement
}

func (s *PostStore) Get(id int) (*domain.User, error) {
	panic("not implemented") // TODO: Implement
}

func (s *PostStore) Update(u *domain.User) error {
	panic("not implemented") // TODO: Implement
}

func (s *PostStore) Delete(u *domain.User) error {
	panic("not implemented") // TODO: Implement
}
