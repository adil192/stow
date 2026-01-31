import 'package:flutter_test/flutter_test.dart';
import 'package:stow/stow.dart';

import 'util/memory_stow.dart';

void main() {
  group('MemoryStow', () {
    const defaultValue = 'default_value';
    const newValue = 'new_value';
    Stow.volatileInTests = false;

    test('Read', () async {
      final stow = MemoryStow<String>('read', defaultValue);
      expect(stow.defaultValue, defaultValue);
      expect(await stow.protectedRead(), defaultValue);
    });

    test('Write', () async {
      final stow = MemoryStow<String>('write', defaultValue);
      stow.value = newValue;
      await null; // Simulate waiting for write to complete
      expect(stow.value, newValue);
      expect(await stow.protectedRead(), newValue);
    });

    test('Key is case-sensitive', () async {
      final stow1 = MemoryStow<String>('key', defaultValue);
      final stow2 = MemoryStow<String>('KEY', defaultValue);
      stow1.value = newValue;
      await null; // Simulate waiting for write to complete
      expect(stow1.value, newValue);
      expect(await stow1.protectedRead(), newValue);
      expect(stow2.value, defaultValue);
      expect(await stow2.protectedRead(), defaultValue);
    });
  });
}
