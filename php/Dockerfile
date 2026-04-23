FROM composer:2 AS builder

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --prefer-dist \
    --no-interaction \
    --no-progress \
    --classmap-authoritative

COPY index.php ./
COPY src ./src
RUN find . -name "*.php" -exec php -l {} \;

FROM php:8.3-cli-alpine AS runner

WORKDIR /app
COPY --from=builder /app/index.php ./
COPY --from=builder /app/src ./src
COPY --from=builder /app/vendor ./vendor

EXPOSE 8080
ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "-t", "/app"]
