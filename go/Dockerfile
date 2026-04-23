FROM golang:1.24-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY main.go ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o service .

FROM debian:12-slim AS runner

WORKDIR /app
COPY --from=builder /app/service /app/service

EXPOSE 8090
ENTRYPOINT ["/app/service"]
