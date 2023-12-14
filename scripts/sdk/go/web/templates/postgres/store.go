package postgres

import (
	"database/sql"
	"fmt"

	"github.com/cethien/go-template/domain"
	_ "github.com/lib/pq"
)

func NewStore(dbUrl string) (*Store, error) {
	db, err := sql.Open("postgres", dbUrl)
	if err != nil {
		return nil, fmt.Errorf("unable to open database: %v", err.Error())
	}

	err = db.Ping()
	if err != nil {
		return nil, fmt.Errorf("unable to connect to db: %v", err.Error())
	}

	return &Store{
		DB:        db,
		UserStore: &UserStore{DB: db},
		PostStore: &PostStore{DB: db},
	}, nil
}

type Store struct {
	*sql.DB
	domain.UserStore
	domain.PostStore
}
