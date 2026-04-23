import 'dart:io';

/// อ่าน .env ทุกครั้งที่ถูกเรียก — live reload เหมือน Rust dotenvy per-request
String? readFromDotenv(String key) {
  try {
    final lines = File('.env').readAsLinesSync();
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final eqIdx = trimmed.indexOf('=');
      if (eqIdx == -1) continue;
      final k = trimmed.substring(0, eqIdx).trim();
      final v = trimmed.substring(eqIdx + 1).trim();
      if (k == key) return v;
    }
  } catch (_) {}
  return null;
}

/// priority: .env file > Platform.environment > fallback (mirrors Rust resolve_config)
String resolveConfig(String key, String fallback) {
  return readFromDotenv(key) ?? Platform.environment[key] ?? fallback;
}
