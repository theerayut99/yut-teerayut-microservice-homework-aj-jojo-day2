FROM dart:stable AS builder

WORKDIR /app
COPY pubspec.yaml pubspec.lock* ./
RUN dart pub get

COPY . .
RUN dart compile exe bin/server.dart -o /app/service

FROM debian:12-slim AS runner

WORKDIR /app
COPY --from=builder /app/service /app/service

EXPOSE 8085
ENTRYPOINT ["/app/service"]
