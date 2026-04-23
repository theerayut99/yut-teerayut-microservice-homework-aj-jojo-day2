package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

// mirrors Rust: #[test] fn test_add()
func TestAdd(t *testing.T) {
	if got := add(1, 2); got != 3 {
		t.Fatalf("add(1,2) = %d, want 3", got)
	}
}

func TestResolveConfigReturnsFallback(t *testing.T) {
	result := resolveConfig("__NO_SUCH_KEY__", "default-value")
	if result != "default-value" {
		t.Fatalf("expected default-value, got %s", result)
	}
}

func TestResolveConfigReturnsEnvVar(t *testing.T) {
	os.Setenv("__TEST_KEY__", "from-env")
	defer os.Unsetenv("__TEST_KEY__")

	result := resolveConfig("__TEST_KEY__", "fallback")
	if result != "from-env" {
		t.Fatalf("expected from-env, got %s", result)
	}
}

func TestRootEndpoint(t *testing.T) {
	r := setupRouter()

	req := httptest.NewRequest(http.MethodGet, "/", nil)
	rr := httptest.NewRecorder()
	r.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d", rr.Code)
	}

	var body map[string]any
	if err := json.Unmarshal(rr.Body.Bytes(), &body); err != nil {
		t.Fatalf("invalid JSON: %v", err)
	}
	if body["message"] != "hello from go" {
		t.Fatalf("unexpected message: %v", body["message"])
	}
}
