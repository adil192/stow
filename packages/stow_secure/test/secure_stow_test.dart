import 'package:flutter_test/flutter_test.dart';
import 'package:stow/stow.dart';
import 'package:stow_codecs/stow_codecs.dart';
import 'package:stow_secure/stow_secure.dart';

import 'util/mock_storage.dart';

void main() {
  group('SecureStow', () {
    setupMockFlutterSecureStorage();
    Stow.volatileInTests = false;

    const defaultValue = 'default_value';
    const newValue = 'new_value';

    test('String, no codec', () async {
      final stow = SecureStow('string_no_codec', defaultValue);
      await stow.waitUntilRead();
      expect(stow.value, defaultValue);

      stow.value = newValue;
      await stow.waitUntilWritten();
      expect(stow.value, newValue);
      expect(await stow.protectedRead(), newValue);
    });

    test('String, with codec', () async {
      final stow = SecureStow(
        'string_with_codec',
        defaultValue,
        codec: IdentityCodec(),
      );
      await stow.waitUntilRead();
      expect(stow.value, defaultValue);

      stow.value = newValue;
      await stow.waitUntilWritten();
      expect(stow.value, newValue);
      expect(await stow.protectedRead(), newValue);
    });

    test('int', () async {
      const defaultValue = 1;
      const newValue = 2;
      final stow = SecureStow.int('int', defaultValue, codec: IdentityCodec());
      await stow.waitUntilRead();
      expect(stow.value, defaultValue);

      stow.value = newValue;
      await stow.waitUntilWritten();
      expect(stow.value, newValue);
      expect(await stow.protectedRead(), newValue.toString());
    });

    test('should delete for default value (no codec)', () async {
      final stow = SecureStow('delete_no_codec', defaultValue);
      await stow.waitUntilRead();
      expect(stow.value, defaultValue);

      stow.value = newValue;
      await stow.waitUntilWritten();
      expect(stow.value, newValue);
      expect(await stow.protectedRead(), newValue);

      stow.value = defaultValue;
      await stow.waitUntilWritten();
      expect(stow.value, defaultValue);
      expect(await stow.protectedRead(), isNull);
    });

    test('should delete for default value (with codec)', () async {
      final stow = SecureStow.int(
        'delete_with_codec',
        _Fruit.cherry,
        codec: _Fruit.codec,
      );
      await stow.waitUntilRead();
      expect(stow.value, _Fruit.cherry);

      stow.value = _Fruit.banana;
      await stow.waitUntilWritten();
      expect(stow.value, _Fruit.banana);
      expect(await stow.protectedRead(), _Fruit.banana.index.toString());

      stow.value = stow.defaultValue;
      await stow.waitUntilWritten();
      expect(stow.value, _Fruit.cherry);
      expect(await stow.protectedRead(), isNull);
    });
  });
}

enum _Fruit {
  apple,
  banana,
  cherry;

  static const codec = EnumCodec(values);
}
