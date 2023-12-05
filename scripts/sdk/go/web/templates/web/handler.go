package web

import (
	"log/slog"
	"net/http"

	"example.com/template/sqlite"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	slogchi "github.com/samber/slog-chi"
)

func NewHandler(store *sqlite.Store) (*Handler, error) {
	tmpls, err := generateTemplatesFromFiles()
	if err != nil {
		return nil, err
	}

	h := &Handler{
		Mux:     chi.NewMux(),
		TmplMap: tmpls,
		Store:   store,
	}

	h.Use(middleware.Recoverer)
	h.Use(middleware.CleanPath)
	h.Use(slogchi.New(slog.Default()))
	h.Use(middleware.Compress(5))

	fs := http.FileServer(http.Dir("public"))
	h.Handle("/*", http.StripPrefix("/", fs))

	h.Get("/", h.RenderIndexPage())

	return h, nil
}

type Handler struct {
	*chi.Mux

	*TmplMap
	*sqlite.Store
}
