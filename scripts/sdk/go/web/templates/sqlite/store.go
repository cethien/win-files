package sqlite

import (
	"database/sql"
	"fmt"

	"example.com/template/domain"
	_ "github.com/mattn/go-sqlite3"
)

func NewStore(dbUrl string) (*Store, error) {
	db, err := sql.Open("sqlite3", dbUrl)
	if err != nil {
		return nil, fmt.Errorf("unable to open database: %v", err.Error())
	}
	err = db.Ping()
	if err != nil {
		return nil, fmt.Errorf("unable to connect to db: %v", err.Error())
	}

	stmts, err := generateMapFromFiles(db)
	if err != nil {
		return nil, fmt.Errorf("unable to generate statement map: %v", err.Error())
	}

	rs := &store{
		DB:       db,
		StmtsMap: stmts,
	}

	return &Store{
		UserStore: &UserStore{store: rs},
		PostStore: &PostStore{store: rs},
	}, nil
}

type store struct {
	*sql.DB
	*StmtsMap
}

type Store struct {
	domain.UserStore
	domain.PostStore
}
