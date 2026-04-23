<?php

declare(strict_types=1);

require __DIR__ . '/src/config.php';

header('Content-Type: application/json');

echo json_encode([
    'message' => 'hello from php',
    'config' => app_config(),
], JSON_UNESCAPED_SLASHES);
