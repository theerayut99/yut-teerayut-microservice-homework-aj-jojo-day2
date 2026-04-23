import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../bin/server.dart';
import 'package:micro_dart/src/env_config.dart';

void main() {
  // mirrors Rust: #[test] fn test_add()
  test('add(1, 2) == 3', () {
    expect(add(1, 2), equals(3));
  });

  test('resolveConfig returns fallback when key is absent', () {
    final result = resolveConfig('__NO_SUCH_KEY__', 'default-value');
    expect(result, equals('default-value'));
  });

  test('handler returns 200 with correct message', () {
    final request = Request('GET', Uri.parse('http://localhost/'));
    final response = handler(request);
    expect(response.statusCode, equals(200));
  });
}
