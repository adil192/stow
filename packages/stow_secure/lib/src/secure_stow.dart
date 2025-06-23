import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stow/stow.dart';
import 'package:stow_codecs/stow_codecs.dart';

/// A [Stow] implementation that stores encrypted values with
/// [FlutterSecureStorage].
class SecureStow<Value> extends Stow<String, Value, String?> {
  /// Creates a [SecureStow] to store encrypted values
  /// using [FlutterSecureStorage].
  ///
  /// This constructor requires the codec to output Strings.
  /// If your codec of choice outputs integers, you can use
  /// [SecureStow.numerical] to automatically convert it to a string.
  SecureStow(super.key, super.defaultValue, [super.codec])
    : assert(key.isNotEmpty),
      assert(
        Value == String || codec != null,
        'SecureStow requires a codec for non-string values.',
      );

  /// Creates a [SecureStow] to store encrypted numerical values
  /// using [FlutterSecureStorage].
  ///
  /// This constructor automatically converts the numerical value to a string
  /// using [IntToStringCodec] before storing it.
  ///
  /// If [Value] is not an integer, you must provide a codec that can convert
  /// the value to an integer, e.g. [EnumCodec] or [ColorCodec].
  factory SecureStow.numerical(
    String key,
    Value defaultValue, [
    Codec<Value, int?>? codec,
  ]) {
    assert(
      Value == int || codec != null,
      'SecureStow.numerical requires a codec for non-integer values.',
    );
    final valueToStringCodec =
        codec?.fuse(const IntToStringCodec()) ??
        (const IntToStringCodec() as Codec<Value, String?>);
    return SecureStow(key, defaultValue, valueToStringCodec);
  }

  @visibleForTesting
  late final storage = FlutterSecureStorage();

  @override
  Future<Value> protectedRead() async {
    final encodedValue = await storage.read(key: key);
    if (encodedValue == null) return defaultValue;

    if (codec == null) {
      // If no codec is provided, we assume the value is directly storable.
      return encodedValue as Value;
    }

    try {
      return codec!.decode(encodedValue);
    } catch (e) {
      // TODO(adil192): Handle decoding errors somehow
      rethrow;
    }
  }

  @override
  Future<void> protectedWrite(Value value) async {
    final String? encodedValue;
    try {
      encodedValue = codec?.encode(value) ?? value as String?;
    } catch (e) {
      // TODO(adil192): Handle encoding errors somehow
      rethrow;
    }

    await storage.write(key: key, value: encodedValue);
  }

  @override
  String toString() => 'SecureStow<$Value>($key, $value, $codec)';
}
