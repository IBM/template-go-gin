package routers

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func SwaggerExplorerRedirect(c *gin.Context) {
	c.Redirect(http.StatusPermanentRedirect, "/explorer/")
}

func SwaggerAPI(c *gin.Context) {
	c.File("./public/swagger.yaml")
}
