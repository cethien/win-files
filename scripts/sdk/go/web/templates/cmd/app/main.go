package main

import (
	"fmt"
	"log/slog"
	"net/http"
	"os/signal"
	"strconv"

	"github.com/cethien/go-web-template/handler"
	"github.com/cethien/go-web-template/sqlite"

	"os"
)

func handleFatal(err error) {
	slog.Error(err.Error())
	os.Exit(1)
}

func main() {
	defer os.Exit(0)

	url, err := getDbUrl()
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}

	store, err := sqlite.NewStore(url)
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}

	handler, err := handler.NewHandler(store)
	if err != nil {
		slog.Error(err.Error())
		os.Exit(1)
	}

	port := getPort()
	addr := fmt.Sprintf(":%v", port)
	http := &http.Server{
		Addr:    addr,
		Handler: handler,
	}
	defer http.Close()

	go func() {
		if err := http.ListenAndServe(); err != nil {
			handleFatal(fmt.Errorf("unable to start http server: %v", err.Error()))
			os.Exit(1)
		}
	}()
	slog.Info(fmt.Sprintf("http server running on http://localhost:%v", port))

	stop := make(chan os.Signal, 1)
	slog.Info("Press Ctrl+C to exit")
	signal.Notify(stop, os.Interrupt)
	<-stop
	slog.Info("shutting down")
}

func getDbUrl() (string, error) {
	dbUrlEnv, ok := os.LookupEnv("DB_URL")
	if !ok {
		return "", fmt.Errorf("env 'DB_URL' not found")
	}

	return dbUrlEnv, nil
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
