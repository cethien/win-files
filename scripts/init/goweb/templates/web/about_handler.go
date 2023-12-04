package web

import (
	"net/http"
)

func (h *Handler) RenderAboutPage() http.HandlerFunc {
	tmpl, err := h.TmplMap.GetPage("about")
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
