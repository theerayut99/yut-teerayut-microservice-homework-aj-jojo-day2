'use strict';

const { test } = require('node:test');
const assert = require('node:assert/strict');
const { add, resolveConfig } = require('../src/main');

// mirror Rust test_add
test('add(1, 2) === 3', () => {
    assert.strictEqual(add(1, 2), 3);
});

test('resolveConfig returns fallback when key is absent', () => {
    const result = resolveConfig('__NO_SUCH_KEY__', 'default-value');
    assert.strictEqual(result, 'default-value');
});

test('resolveConfig returns process.env value when .env has no key', () => {
    process.env['__TEST_KEY__'] = 'from-env';
    const result = resolveConfig('__TEST_KEY__', 'default-value');
    assert.strictEqual(result, 'from-env');
    delete process.env['__TEST_KEY__'];
});
