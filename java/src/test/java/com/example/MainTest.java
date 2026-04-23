package com.example;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class MainTest {

    // mirrors Rust: #[test] fn test_add()
    @Test
    void testAdd() {
        assertEquals(3, Main.add(1, 2));
    }

    @Test
    void resolveConfigReturnsFallbackWhenAbsent() {
        String result = EnvConfig.resolveConfig("__NO_SUCH_KEY__", "default-value");
        assertEquals("default-value", result);
    }

    @Test
    void resolveConfigReturnsEnvVarWhenDotenvMissingKey() {
        // KEY ที่ไม่มีใน .env และไม่มีใน System.getenv → คืน fallback
        String result = EnvConfig.resolveConfig("__ANOTHER_MISSING_KEY__", "fallback");
        assertEquals("fallback", result);
    }
}

