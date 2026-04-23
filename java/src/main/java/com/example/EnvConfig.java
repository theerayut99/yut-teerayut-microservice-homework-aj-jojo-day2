package com.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Optional;

public class EnvConfig {

    // อ่าน .env ทุกครั้งที่ถูกเรียก — live reload
    public static Optional<String> readFromDotenv(String key) {
        try {
            String content = Files.readString(Paths.get(".env"));
            for (String line : content.split("\n")) {
                String trimmed = line.strip();
                if (trimmed.isEmpty() || trimmed.startsWith("#")) continue;
                int eqIdx = trimmed.indexOf('=');
                if (eqIdx == -1) continue;
                String k = trimmed.substring(0, eqIdx).strip();
                String v = trimmed.substring(eqIdx + 1).strip();
                if (k.equals(key)) return Optional.of(v);
            }
        } catch (IOException ignored) {}
        return Optional.empty();
    }

    // priority: .env file > System.getenv > fallback
    public static String resolveConfig(String key, String fallback) {
        return readFromDotenv(key)
                .or(() -> Optional.ofNullable(System.getenv(key)))
                .orElse(fallback);
    }
}
