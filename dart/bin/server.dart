import 'dart:convert';

import 'package:micro_dart/src/env_config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

int add(int a, int b) => a + b;

Response handler(Request request) {
  final databaseUrl =
      resolveConfig('DATABASE_URI', 'postgres://localhost:5432/app');
  final redisEndpoint =
      resolveConfig('REDIS_ENDPOINT', 'redis://localhost:6379');

  return Response.ok(
    jsonEncode({
      'message': 'hello from dart',
      'config': {
        'database_url': databaseUrl,
        'redis_endpoint': redisEndpoint,
      },
    }),
    headers: {'content-type': 'application/json'},
  );
}

Future<void> main() async {
  final port = int.tryParse(resolveConfig('PORT', '8085')) ?? 8085;
  final server = await shelf_io.serve(handler, '0.0.0.0', port);
  print('Dart service running on port ${server.port}');
}
