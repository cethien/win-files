package config

import (
	"fmt"
	"log/slog"
	"os"
	"strconv"
)

type Config struct {
	AppName         string
	DbUrl           string
	DbMigrationsUrl string
	HttpPort        int
}

var (
	appName string = "Go Web Template"
	Global  *Config
)

func LoadConfig() error {
	dbUrl, ok := os.LookupEnv("DB_URL")
	if !ok {
		return fmt.Errorf("environment variable 'DB_URL' not found")
	}

	dbMigrationsUrl, ok := os.LookupEnv("DB_MIGRATIONS_URL")
	if !ok {
		return fmt.Errorf("environment variable 'DB_MIGRATIONS_URL' not found")
	}

	Global = &Config{
		AppName:         appName,
		DbUrl:           dbUrl,
		DbMigrationsUrl: dbMigrationsUrl,
		HttpPort:        getPort(),
	}

	return nil
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
