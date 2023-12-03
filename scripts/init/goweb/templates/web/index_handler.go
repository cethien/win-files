package web

import (
	"fmt"
	"log/slog"
	"net/http"
)

func handleError(err error) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		slog.Error(fmt.Sprintf("handling error: %v", err))
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func (h *Handler) RenderIndexPage() http.HandlerFunc {
	tmpl, err := h.TmplMap.GetPage("index")
	if err != nil {
		return handleError(err)
	}

	return func(w http.ResponseWriter, r *http.Request) {
		err := tmpl.ExecuteTemplate(w, "layout", nil)
		if err != nil {
			handleError(err)
		}
	}
}
