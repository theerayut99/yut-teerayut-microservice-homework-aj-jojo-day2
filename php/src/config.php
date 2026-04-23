<?php

declare(strict_types=1);

function load_runtime_dotenv(): void {
    static $autoloaded = false;

    if (!$autoloaded) {
        $autoloadPath = __DIR__ . '/../vendor/autoload.php';
        if (file_exists($autoloadPath)) {
            require_once $autoloadPath;
        }
        $autoloaded = true;
    }

    if (class_exists(\Dotenv\Dotenv::class)) {
        $dotenv = \Dotenv\Dotenv::createMutable(__DIR__ . '/..');
        $dotenv->safeLoad();
    }
}

function app_config(): array {
    // Reload .env
    load_runtime_dotenv();

    $databaseUri = $_ENV['DATABASE_URI'] ?? getenv('DATABASE_URI') ?: 'postgres://localhost:5432/php';
    $redisEndpoint = $_ENV['REDIS_ENDPOINT'] ?? getenv('REDIS_ENDPOINT') ?: 'redis://localhost:6379';

    return [
        'database_url' => $databaseUri,
        'redis_endpoint' => $redisEndpoint,
    ];
}
