package main

import (
	"bufio"
	"fmt"
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
)

// readFromDotenv อ่าน .env ทุกครั้งที่ถูกเรียก — live reload
func readFromDotenv(key string) (string, bool) {
	f, err := os.Open(".env")
	if err != nil {
		return "", false
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		eqIdx := strings.IndexByte(line, '=')
		if eqIdx == -1 {
			continue
		}
		k := strings.TrimSpace(line[:eqIdx])
		v := strings.TrimSpace(line[eqIdx+1:])
		if k == key {
			return v, true
		}
	}
	return "", false
}

// resolveConfig: priority .env > os.Getenv > fallback
func resolveConfig(key, fallback string) string {
	if v, ok := readFromDotenv(key); ok {
		return v
	}
	if v, ok := os.LookupEnv(key); ok {
		return v
	}
	return fallback
}

func add(a, b int) int {
	return a + b
}

func setupRouter() *gin.Engine {
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()

	r.GET("/", func(c *gin.Context) {
		databaseURL := resolveConfig("DATABASE_URI", "postgres://localhost:5432/app")
		redisEndpoint := resolveConfig("REDIS_ENDPOINT", "redis://localhost:6379")

		c.JSON(http.StatusOK, gin.H{
			"message": "hello from go",
			"config": gin.H{
				"database_url":   databaseURL,
				"redis_endpoint": redisEndpoint,
			},
		})
	})

	return r
}

func main() {
	port := resolveConfig("PORT", "8090")
	fmt.Printf("Go service running on port %s\n", port)
	setupRouter().Run("0.0.0.0:" + port)
}
