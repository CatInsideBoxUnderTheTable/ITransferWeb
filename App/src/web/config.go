package web

import (
	"crypto/subtle"
	"fmt"
	"log"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type Controller struct {
	Path               string
	ControllerListener func(c echo.Context) error
}

type AuthConfig struct {
	Login    string
	Password string
}

func SetupHttpServer(controllers []Controller, port string, authConfig AuthConfig) {
	authSetupClosure := func(username, password string, c echo.Context) (bool, error) {
		return AuthSetup(username, password, c, authConfig)
	}

	log.Print("HTTP SERVER SETUP")
	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(middleware.BodyDump(Dump))
	e.Use(middleware.BasicAuth(authSetupClosure))

	log.Print("CONTROLLERS SETUP")
	for i := 0; i < len(controllers); i++ {
		controller := controllers[i]

		log.Printf("Setting up controller for: %s", controller.Path)
		e.GET(controller.Path, controller.ControllerListener)
		log.Print("Setup done")
	}

	log.Print("HTTP SERVER STARTUP")
	e.Logger.Fatal(e.Start(fmt.Sprintf(":%s", port)))
}

func AuthSetup(username, password string, c echo.Context, config AuthConfig) (bool, error) {
	if subtle.ConstantTimeCompare([]byte(username), []byte(config.Login)) == 1 &&
		subtle.ConstantTimeCompare([]byte(password), []byte(config.Password)) == 1 {
		return true, nil
	}
	return false, nil
}

func Dump(c echo.Context, reqBody, resBody []byte) {
	log.Print(c.Request().Header)
}
