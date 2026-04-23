use actix_web::{get, web::Json, App, HttpServer};
use serde_json::{json, Value};

fn read_from_dotenv(key: &str) -> Option<String> {
    let entries = dotenvy::from_path_iter(".env").ok()?;
    for item in entries.flatten() {
        if item.0 == key {
            return Some(item.1);
        }
    }
    None
}

fn resolve_config(key: &str, fallback: &str) -> String {
    read_from_dotenv(key)
        .or_else(|| std::env::var(key).ok())
        .unwrap_or_else(|| fallback.to_string())
}

#[get("/")]
async fn greet() -> Json<Value> {
    let database_url = resolve_config("DATABASE_URI", "postgres://localhost:5432/app");
    let redis_endpoint = resolve_config("REDIS_ENDPOINT", "redis://localhost:6379");

    Json(json!({
        "message": "hello from rust",
        "config": {
            "database_url": database_url,
            "redis_endpoint": redis_endpoint
        }
    }))
}

#[actix_web::main] // or #[tokio::main]
async fn main() -> std::io::Result<()> {
    let port: u16 = std::env::var("PORT")
        .ok()
        .and_then(|v| v.parse::<u16>().ok())
        .unwrap_or(3030);

    HttpServer::new(|| {
        App::new().service(greet)
    })
    .bind(("0.0.0.0", port))?
    .run()
    .await
}

pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

// This is a really bad adding function, its purpose is to fail in this
// example.
#[allow(dead_code)]
fn bad_add(a: i32, b: i32) -> i32 {
    a - b
}

#[cfg(test)]
mod tests {
    // Note this useful idiom: importing names from outer (for mod tests) scope.
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(1, 2), 3);
    }

    // #[test]
    // fn test_bad_add() {
    //     // This assert would fire and test will fail.
    //     // Please note, that private functions can be tested too!
    //     assert_eq!(bad_add(1, 2), 3);
    // }
}