#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="teerayuttanyaphu/micro-js:latest"
CONTAINER_NAME="micro-js"
DOCKER_USERNAME="${DOCKER_USERNAME:-teerayuttanyaphu}"

docker_login() {
	if [[ -n "${DOCKER_ACCESS_TOKEN:-}" ]]; then
		printf '%s' "${DOCKER_ACCESS_TOKEN}" | docker login --username "${DOCKER_USERNAME}" --password-stdin
	else
		echo "DOCKER_ACCESS_TOKEN is not set."
		docker login --username "${DOCKER_USERNAME}"
	fi
}

npm install --no-audit --no-fund

echo "[1/4] Lint"
find src -name "*.js" -print0 | xargs -0 -n1 node --check

echo "[2/4] Test"
node --test tests/main.test.js

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
	-p 3003:3000 \
	-v "$(pwd)/.env:/app/.env:ro" \
	"${IMAGE_NAME}"

echo "JavaScript service is running at http://localhost:3003"
