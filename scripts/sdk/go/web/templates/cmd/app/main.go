package main

import (
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os/signal"

	"github.com/cethien/go-web-template/config"
	"github.com/cethien/go-web-template/handler"
	"github.com/cethien/go-web-template/postgres"
	"github.com/golang-migrate/migrate/v4"

	"os"
)

func main() {
	defer os.Exit(0)
	defer slog.Info("bye!")

	slog.Info("launching...")
	err := config.LoadConfig()
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}

	store, err := postgres.NewStore()
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}
	defer store.DB.Close()
	slog.Info("connected to database")

	err = store.Migrate.Up()
	if err != nil && err != migrate.ErrNoChange {
		slog.Error(err.Error())
		os.Exit(1)
	}

	handler, err := handler.NewHandler(store)
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}

	addr := fmt.Sprintf(":%v", config.Global.HttpPort)
	httpSrv := &http.Server{
		Addr:    addr,
		Handler: handler,
	}

	go func() {
		err = httpSrv.ListenAndServe()
	}()
	if err != nil {
		if !errors.Is(err, http.ErrServerClosed) {
			err = fmt.Errorf("unable to start http server: %v", err)
			slog.Error(err.Error())
		}
	}
	slog.Info(fmt.Sprintf("http server running on http://localhost:%v", config.Global.HttpPort))

	stop := make(chan os.Signal, 1)
	signal.Notify(stop, os.Interrupt)
	slog.Info("Press Ctrl+C to exit")
	<-stop
}
