package postgres

import (
	"database/sql"
	"fmt"

	"github.com/cethien/go-web-template/config"
	"github.com/cethien/go-web-template/domain"
	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
)

func NewStore() (*Store, error) {
	db, err := sql.Open("postgres", config.Global.DbUrl)
	if err != nil {
		return nil, fmt.Errorf("unable to open database: %v", err.Error())
	}

	m, err := migrate.New(config.Global.DbMigrationsUrl, config.Global.DbUrl)
	if err != nil {
		return nil, fmt.Errorf("unable to create new db migrator: %v", err.Error())
	}

	err = db.Ping()
	if err != nil {
		return nil, fmt.Errorf("unable to connect to db: %v", err.Error())
	}

	return &Store{
		DB:        db,
		Migrate:   m,
		UserStore: &UserStore{DB: db},
		PostStore: &PostStore{DB: db},
	}, nil
}

type Store struct {
	*sql.DB
	*migrate.Migrate
	domain.UserStore
	domain.PostStore
}
