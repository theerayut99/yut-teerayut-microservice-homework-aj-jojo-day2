#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="teerayuttanyaphu/micro-php:latest"
CONTAINER_NAME="micro-php"
DOCKER_USERNAME="${DOCKER_USERNAME:-teerayuttanyaphu}"

docker_login() {
	if [[ -n "${DOCKER_ACCESS_TOKEN:-}" ]]; then
		printf '%s' "${DOCKER_ACCESS_TOKEN}" | docker login --username "${DOCKER_USERNAME}" --password-stdin
	else
		echo "DOCKER_ACCESS_TOKEN is not set."
		docker login --username "${DOCKER_USERNAME}"
	fi
}

docker run --rm -v "$(pwd)":/app -w /app composer:2 composer install --no-interaction --prefer-dist

echo "[1/4] Lint"
find . -name "*.php" -print0 | xargs -0 -n1 php -l

echo "[2/4] Test"
php tests/config_test.php

echo "[3/4] Build & Publish image"
docker_login
docker build -t "${IMAGE_NAME}" .
docker push "${IMAGE_NAME}"

echo "[4/4] Deploy"
if [[ ! -f .env ]]; then
	echo ".env file not found."
	exit 1
fi

docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
docker run -d --name "${CONTAINER_NAME}" \
  -p 3002:8080 \
  -v "$(pwd)/.env:/app/.env:ro" \
  "${IMAGE_NAME}"

echo "PHP service is running at http://localhost:3002"
