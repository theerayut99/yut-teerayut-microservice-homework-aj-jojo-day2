#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="teerayuttanyaphu/micro-csharp:latest"
CONTAINER_NAME="micro-csharp"
DOCKER_USERNAME="${DOCKER_USERNAME:-teerayuttanyaphu}"

docker_login() {
	if [[ -n "${DOCKER_ACCESS_TOKEN:-}" ]]; then
		printf '%s' "${DOCKER_ACCESS_TOKEN}" | docker login --username "${DOCKER_USERNAME}" --password-stdin
	else
		echo "DOCKER_ACCESS_TOKEN is not set."
		docker login --username "${DOCKER_USERNAME}"
	fi
}

echo "[1/4] Lint"
dotnet build src/CSharpService.csproj -warnaserror

echo "[2/4] Test"
dotnet test tests/CSharpService.Tests/CSharpService.Tests.csproj

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
	-p 3007:8080 \
	-v "$(pwd)/.env:/app/.env:ro" \
	"${IMAGE_NAME}"

echo "C# service is running at http://localhost:3007"
