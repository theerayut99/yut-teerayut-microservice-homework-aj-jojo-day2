<?php

declare(strict_types=1);

require __DIR__ . '/../src/config.php';

$envPath = __DIR__ . '/../.env';
$backupEnvPath = __DIR__ . '/../.env.test.backup';
$hasEnv = file_exists($envPath);

if ($hasEnv) {
    rename($envPath, $backupEnvPath);
}

try {
    putenv('DATABASE_URI=postgres://test-db');
    putenv('REDIS_ENDPOINT=redis://test-redis');
    $_ENV['DATABASE_URI'] = 'postgres://test-db';
    $_ENV['REDIS_ENDPOINT'] = 'redis://test-redis';

    $config = app_config();

    if ($config['database_url'] !== 'postgres://test-db') {
        fwrite(STDERR, "database_url assertion failed\n");
        exit(1);
    }

    if ($config['redis_endpoint'] !== 'redis://test-redis') {
        fwrite(STDERR, "redis_endpoint assertion failed\n");
        exit(1);
    }

    echo "php tests passed\n";
} finally {
    if ($hasEnv) {
        rename($backupEnvPath, $envPath);
    }
}
