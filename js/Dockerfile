FROM oven/bun:1 AS builder

WORKDIR /app
COPY package.json ./
RUN bun install --production

COPY src ./src
RUN bun build --compile --minify src/main.js --outfile service

FROM debian:12-slim AS runner

WORKDIR /app
COPY --from=builder /app/service /app/service

EXPOSE 3000
ENTRYPOINT ["/app/service"]
