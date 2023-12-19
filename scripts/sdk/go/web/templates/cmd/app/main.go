package main

import (
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os/signal"
	"strconv"

	"github.com/cethien/go-web-template/handler"
	"github.com/cethien/go-web-template/postgres"

	"os"
)

func main() {
	defer os.Exit(0)
	defer slog.Info("bye!")
	slog.Info("launching...")

	url, err := getDbUrl()
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}

	store, err := postgres.NewStore(url)
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}
	defer store.DB.Close()
	slog.Info("connected to database")

	handler, err := handler.NewHandler(store)
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}

	port := getPort()
	addr := fmt.Sprintf(":%v", port)
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
	slog.Info(fmt.Sprintf("http server running on http://localhost:%v", port))

	stop := make(chan os.Signal, 1)
	signal.Notify(stop, os.Interrupt)
	slog.Info("Press Ctrl+C to exit")
	<-stop
}

func getDbUrl() (string, error) {
	env, ok := os.LookupEnv("DB_URL")
	if !ok {
		return "", fmt.Errorf("environment variable 'DB_URL' not found")
	}

	return env, nil
}

func getPort() int {
	portEnv, ok := os.LookupEnv("PORT")
	if ok {
		i, err := strconv.Atoi(portEnv)
		if err != nil {
			slog.Error(fmt.Sprintf("value '%v' of env 'PORT' is not valid", portEnv))
		} else {
			return i
		}
	}

	if os.Getenv("APP_ENV") == "development" {
		return 8080
	}

	return 80
}
