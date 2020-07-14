package main

import (
	"github.com/IBM/go-gin-app/routers"
	// "goginapp/plugins" if you create your own plugins import them here
	"github.com/gin-contrib/static"
	"github.com/gin-gonic/gin"
	log "github.com/sirupsen/logrus"
	"os"
)

func port() string {
	port := os.Getenv("PORT")
	if len(port) == 0 {
		port = "8080"
	}
	return ":" + port
}

func main() {

	log.SetFormatter(&log.JSONFormatter{})
	log.SetOutput(os.Stdout)

	router := gin.Default()
	router.RedirectTrailingSlash = false

	// Swagger endpoints
	router.GET("/explorer", routers.SwaggerExplorerRedirect)
	router.GET("/swagger/api", routers.SwaggerAPI)
	router.Use(static.Serve("/explorer/", static.LocalFile("./public/swagger-ui/", true)))

	// Static webpage content endpoints
	router.LoadHTMLGlob("public/*.html")
	router.Use(static.Serve("/", static.LocalFile("./public", false)))
	router.GET("/", routers.Index)
	router.NoRoute(routers.NotFoundError)
	router.GET("/500", routers.InternalServerError)

	// Health endpoint
	router.GET("/health", routers.HealthGET)

	log.Info("Starting Server on port " + port())

	router.Run(port())
}
