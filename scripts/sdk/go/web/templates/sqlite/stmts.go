package sqlite

import (
	"database/sql"
	"embed"
	"fmt"
	"io/fs"
	"path/filepath"
	"strings"
)

type StmtsMap map[string]*sql.Stmt

var (
	sqlFilesDir = "sql"
	//go:embed all:sql
	sqlFiles embed.FS
)

func (m *StmtsMap) GetStmt(group string, name string) (*sql.Stmt, error) {
	key := group + "/" + name
	stmt, ok := (*m)[key]
	if !ok {
		return nil, fmt.Errorf("statement '%v' not found", key)
	}

	return stmt, nil
}

func generateMapFromFiles(db *sql.DB) (*StmtsMap, error) {
	qs := make(StmtsMap)
	err := fs.WalkDir(sqlFiles, sqlFilesDir, func(path string, d fs.DirEntry, err error) error {
		if !d.IsDir() {
			buff, err := sqlFiles.ReadFile(path)
			if err != nil {
				return err
			}

			sql := string(buff)
			stmt, err := db.Prepare(sql)
			if err != nil {
				return err
			}
			key := strings.TrimSuffix(strings.TrimPrefix(path, sqlFilesDir+"/"), filepath.Ext(path))
			qs[key] = stmt
		}

		return nil
	})
	if err != nil {
		return nil, err
	}

	return &qs, nil
}
