package web

import (
	"embed"
	"fmt"
	"html/template"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

var (
	templateDir = "templates"
	layoutsDir  = "templates/layouts"

	//go:embed all:templates
	templatesFS embed.FS
)

type TmplMap map[string]*template.Template

func (m *TmplMap) GetPage(name string) (*template.Template, error) {
	tmpl, ok := (*m)[name]
	if !ok {
		return nil, fmt.Errorf("'%v' not found", name)
	}

	return tmpl, nil
}

func generateTemplatesFromFiles() (*TmplMap, error) {
	var funcs = template.FuncMap{
		"dev": func() bool {
			return os.Getenv("APP_ENV") == "development"
		},
		"AppName": func() string {
			return "Go Web App"
		},
		"arr": func(els ...any) []any {
			return els
		},
	}

	tmpls := make(TmplMap)
	if err := fs.WalkDir(templatesFS, templateDir, func(path string, d fs.DirEntry, err error) error {
		if !d.IsDir() {
			name := strings.TrimPrefix(strings.TrimSuffix(path, filepath.Ext(path)), templateDir+"/")

			tmpl, err := template.
				New("").
				Funcs(funcs).
				ParseFS(templatesFS, path, layoutsDir+"/page.html")
			if err != nil {
				return err
			}
			tmpls[name] = tmpl
		}
		return nil
	}); err != nil {
		return nil, err
	}

	return &tmpls, nil
}
