package main

import (
	"github.com/go-resty/resty/v2"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {

	e := echo.New()

	// Middleware
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// Routes
	e.GET("/", httpbinGet)

	// Start server
	e.Logger.Fatal(e.Start(":8080"))
}

func httpbinGet(c echo.Context) error {

	client := resty.New()

	resp, err := client.R().
		EnableTrace().
		SetHeaders(map[string]string{
			"Accept-Encoding": "gzip, deflate, br",
			"Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
			"Referer":         "https://httpbin.org/",
			"x-my-header":     "harness-tutorial-demo",
		}).
		Get("https://httpbin.org/get")

	if err != nil {
		return err
	}

	rb := resp.Body()

	c.Response().Header().Set(echo.HeaderContentType, echo.MIMEApplicationJSONCharsetUTF8)
	c.Response().WriteHeader(resp.StatusCode())
	_, err = c.Response().Write(rb)

	if err != nil {
		return err
	}

	return nil
}
