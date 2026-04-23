package com.example;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class HelloController {

    @GetMapping("/")
    public Map<String, Object> hello() {
        String databaseUrl = EnvConfig.resolveConfig("DATABASE_URI", "postgres://localhost:5432/app");
        String redisEndpoint = EnvConfig.resolveConfig("REDIS_ENDPOINT", "redis://localhost:6379");

        return Map.of(
            "message", "hello from java",
            "config", Map.of(
                "database_url", databaseUrl,
                "redis_endpoint", redisEndpoint
            )
        );
    }
}
