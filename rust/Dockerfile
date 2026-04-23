FROM rust:1.94-slim AS builder

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN cargo build --release

FROM debian:12-slim AS runner

WORKDIR /app
COPY --from=builder /app/target/release/rust /app/rust

EXPOSE 3030
ENTRYPOINT ["/app/rust"]
