import 'package:flutter_test/flutter_test.dart';
import 'package:stow_codecs/stow_codecs.dart';
import 'package:stow_secure/stow_secure.dart';

import 'util/mock_storage.dart';

void main() {
  group('SecureStow', () {
    setupMockFlutterSecureStorage();

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
      final stow = SecureStow.int(
        'int',
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
  });
}
