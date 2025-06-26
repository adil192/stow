import 'dart:convert';
import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:stow_codecs/stow_codecs.dart';
import 'package:stow_plain/stow_plain.dart';

typedef JsonMap = Map<String, dynamic>;

void main() {
  group('PlainStow', () {
    const defaultValue = 'default_value';
    const newValue = 'new_value';
    const existingValue = 'existing_value';
    SharedPreferences.setMockInitialValues({
      'existing': existingValue,

      // shared_preferences casts from dynamic to string because of platform differences
      'existing_list': List<dynamic>.from([existingValue]),
    });

    test('Read when not present', () async {
      final stow = PlainStow('missing', defaultValue);

      await stow.waitUntilRead();
      expect(stow.value, defaultValue);

      expect(await stow.protectedRead(), defaultValue);
    });

    test('Read when present', () async {
      final stow = PlainStow('existing', defaultValue);

      await stow.waitUntilRead();
      expect(stow.value, existingValue);

      expect(await stow.protectedRead(), existingValue);
    });

    test('Write', () async {
      final stow = PlainStow('write', defaultValue);
      await stow.waitUntilRead();

      stow.value = newValue;
      await stow.waitUntilWritten();

      expect(stow.value, newValue);
      expect(await stow.protectedRead(), newValue);
    });

    test('Key is case-sensitive', () async {
      final stow1 = PlainStow('key', defaultValue);
      final stow2 = PlainStow('KEY', defaultValue);
      await stow1.waitUntilRead();
      await stow2.waitUntilRead();

      stow1.value = newValue;
      await stow1.waitUntilWritten();

      expect(stow1.value, newValue);
      expect(await stow1.protectedRead(), newValue);
      expect(stow2.value, defaultValue);
      expect(await stow2.protectedRead(), defaultValue);
    });

    test('List<String>', () async {
      final stow = PlainStow<List<String>>('existing_list', []);
      await stow.waitUntilRead();
      expect(stow.value, [existingValue]);

      final list = ['item1', 'item2', 'item3'];
      stow.value = list;
      await stow.waitUntilWritten();
      expect(stow.value, list);
      expect(await stow.protectedRead(), list);
    });

    test('json (primitive)', () async {
      final objectDecoded = {'key': 'value', 'number': 42};
      final objectEncoded = jsonEncode(objectDecoded);
      final arrayDecoded = ['item1', 'item2', 3.14, false];
      final arrayEncoded = jsonEncode(arrayDecoded);

      final stowWithCodec = PlainStow<Object>.json('json', {});
      final stowWithoutCodec = PlainStow('json', '{}');
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

    test('color', () async {
      final white = const Color(0xFFFFFFFF);
      final red = const Color(0xFFFF0000);

      final stow = PlainStow('color', white, codec: ColorCodec());
      await stow.waitUntilRead();

      stow.value = red;
      await stow.waitUntilWritten();
      expect(stow.value, red);
      expect(await stow.protectedRead(), red);
    });

    test('enum', () async {
      final stow = PlainStow('pet', Pet.cat, codec: EnumCodec(Pet.values));
      await stow.waitUntilRead();

      stow.value = Pet.dog;
      await stow.waitUntilWritten();
      expect(stow.value, Pet.dog);
      expect(await stow.protectedRead(), Pet.dog);
    });
  });
}

enum Pet { cat, dog, fish }

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
