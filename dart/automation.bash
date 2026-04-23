#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="teerayuttanyaphu/micro-dart:latest"
CONTAINER_NAME="micro-dart"
DOCKER_USERNAME="${DOCKER_USERNAME:-teerayuttanyaphu}"

docker_login() {
	if [[ -n "${DOCKER_ACCESS_TOKEN:-}" ]]; then
		printf '%s' "${DOCKER_ACCESS_TOKEN}" | docker login --username "${DOCKER_USERNAME}" --password-stdin
	else
		echo "DOCKER_ACCESS_TOKEN is not set."
		docker login --username "${DOCKER_USERNAME}"
	fi
}

dart pub get

echo "[1/4] Lint"
dart format .
dart analyze

echo "[2/4] Test"
dart test

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
	-p 3006:8085 \
	-v "$(pwd)/.env:/app/.env:ro" \
	"${IMAGE_NAME}"

echo "Dart service is running at http://localhost:3006"
