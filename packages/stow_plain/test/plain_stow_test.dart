import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stow_plain/stow_plain.dart';

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
  });
}
