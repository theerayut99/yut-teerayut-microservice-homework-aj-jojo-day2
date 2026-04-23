'use strict';

const fs = require('fs');
const path = require('path');
const express = require('express');

// อ่าน .env ทุกครั้งที่ถูกเรียก (live reload)
function readFromDotenv(key) {
    try {
        const envPath = path.resolve(process.cwd(), '.env');
        const content = fs.readFileSync(envPath, 'utf8');
        for (const line of content.split('\n')) {
            const trimmed = line.trim();
            if (!trimmed || trimmed.startsWith('#')) continue;
            const eqIdx = trimmed.indexOf('=');
            if (eqIdx === -1) continue;
            const k = trimmed.slice(0, eqIdx).trim();
            const v = trimmed.slice(eqIdx + 1).trim();
            if (k === key) return v;
        }
    } catch (_) {}
    return undefined;
}

// priority: .env file > process.env > hardcoded default
function resolveConfig(key, fallback) {
    return readFromDotenv(key) ?? process.env[key] ?? fallback;
}

const app = express();

app.get('/', (req, res) => {
    const databaseUrl = resolveConfig('DATABASE_URI', 'postgres://localhost:5432/app');
    const redisEndpoint = resolveConfig('REDIS_ENDPOINT', 'redis://localhost:6379');

    res.json({
        message: 'hello from javascript',
        config: {
            database_url: databaseUrl,
            redis_endpoint: redisEndpoint,
        },
    });
});

const port = Number(process.env.PORT) || 3000;
if (require.main === module) {
    app.listen(port, '0.0.0.0', () => {
        console.log(`JavaScript service running on port ${port}`);
    });
}

function add(a, b) {
    return a + b;
}

module.exports = { add, readFromDotenv, resolveConfig };
