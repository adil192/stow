import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stow_plain/stow_plain.dart';

typedef JsonMap = Map<String, dynamic>;

void main() {
  group('PlainStow', () {
    const defaultValue = 'default_value';
    const newValue = 'new_value';
    const existingValue = 'existing_value';
    SharedPreferences.setMockInitialValues({'existing': existingValue});

    test('Read when not present', () async {
      final stow = PlainStow.simple('missing', defaultValue);

      await stow.waitUntilRead();
      expect(stow.value, defaultValue);

      expect(await stow.protectedRead(), defaultValue);
    });

    test('Read when present', () async {
      final stow = PlainStow.simple('existing', defaultValue);

      await stow.waitUntilRead();
      expect(stow.value, existingValue);

      expect(await stow.protectedRead(), existingValue);
    });

    test('Write', () async {
      final stow = PlainStow.simple('write', defaultValue);
      await stow.waitUntilRead();

      stow.value = newValue;
      await stow.waitUntilWritten();

      expect(stow.value, newValue);
      expect(await stow.protectedRead(), newValue);
    });

    test('Key is case-sensitive', () async {
      final stow1 = PlainStow.simple('key', defaultValue);
      final stow2 = PlainStow.simple('KEY', defaultValue);
      await stow1.waitUntilRead();
      await stow2.waitUntilRead();

      stow1.value = newValue;
      await stow1.waitUntilWritten();

      expect(stow1.value, newValue);
      expect(await stow1.protectedRead(), newValue);
      expect(stow2.value, defaultValue);
      expect(await stow2.protectedRead(), defaultValue);
    });

    test('json (primitive)', () async {
      final objectDecoded = {'key': 'value', 'number': 42};
      final objectEncoded = jsonEncode(objectDecoded);
      final arrayDecoded = ['item1', 'item2', 3.14, false];
      final arrayEncoded = jsonEncode(arrayDecoded);

      final stowWithCodec = PlainStow<Object>.json('json', {});
      final stowWithoutCodec = PlainStow.simple('json', '{}');
      await stowWithCodec.waitUntilRead();
      await stowWithoutCodec.waitUntilRead();
      expect(stowWithCodec.value, const {});
      expect(stowWithoutCodec.value, '{}');

      stowWithCodec.value = objectDecoded;
      await stowWithCodec.waitUntilWritten();
      expect(await stowWithoutCodec.protectedRead(), objectEncoded);

      stowWithoutCodec.value = arrayEncoded;
      await stowWithoutCodec.waitUntilWritten();
      expect(await stowWithCodec.protectedRead(), arrayDecoded);
    });

    test('json (non-primitive)', () async {
      final wrapInt1 = _WrappedInteger(123);

      final stow = PlainStow.json(
        'wrap_int',
        const _WrappedInteger(0),
        fromJson: (json) => _WrappedInteger.fromJson(json as JsonMap),
      );
      await stow.waitUntilRead();

      stow.value = wrapInt1;
      await stow.waitUntilWritten();
      expect(stow.value, wrapInt1);
      expect(await stow.protectedRead(), wrapInt1);
    });
  });
}

class _WrappedInteger {
  const _WrappedInteger(this.value);

  final int value;

  _WrappedInteger.fromJson(JsonMap json) : value = json['value'] as int;
  Map<String, dynamic> toJson() => {'value': value};

  @override
  bool operator ==(Object other) =>
      other is _WrappedInteger && other.value == value;
  @override
  int get hashCode => value.hashCode;
  @override
  String toString() => 'WrappedInteger($value)';
}
