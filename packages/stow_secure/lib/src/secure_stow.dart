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
  /// If your codec of choice outputs something else, consider using:
  /// - [SecureStow.int] for integers
  /// - [SecureStow.bool] for booleans
  SecureStow(super.key, super.defaultValue, {super.codec, super.volatile})
    : assert(key.isNotEmpty),
      assert(
        Value == String || codec != null,
        'SecureStow requires a codec for non-string values.',
      );

  /// Creates a [SecureStow] to store encrypted integer values
  /// using [FlutterSecureStorage].
  ///
  /// This constructor automatically converts the integer value to a string
  /// using [IntToStringCodec] before storing it.
  ///
  /// If [Value] is not an integer, you must provide a codec that can convert
  /// the value to an integer, e.g. [EnumCodec] or [ColorCodec].
  factory SecureStow.int(
    String key,
    Value defaultValue, {
    Codec<Value, int?>? codec,
    bool volatile = false,
  }) {
    assert(
      Value == int || codec != null,
      'SecureStow.int requires a codec for non-integer values.',
    );
    final valueToStringCodec =
        codec?.fuse(const IntToStringCodec()) ??
        (const IntToStringCodec() as Codec<Value, String?>);
    return SecureStow(
      key,
      defaultValue,
      codec: valueToStringCodec,
      volatile: volatile,
    );
  }

  /// Creates a [SecureStow] to store encrypted boolean values
  /// using [FlutterSecureStorage].
  ///
  /// This constructor automatically converts the boolean value to a string
  /// using [BoolToStringCodec] before storing it.
  ///
  /// If [Value] is not a boolean, you must provide a codec that can convert
  /// the value to a boolean.
  factory SecureStow.bool(
    String key,
    Value defaultValue, {
    Codec<Value, bool?>? codec,
    bool volatile = false,
  }) {
    assert(
      Value == bool || codec != null,
      'SecureStow.bool requires a codec for non-boolean values.',
    );
    final valueToStringCodec =
        codec?.fuse(const BoolToStringCodec()) ??
        (const BoolToStringCodec() as Codec<Value, String?>);
    return SecureStow(
      key,
      defaultValue,
      codec: valueToStringCodec,
      volatile: volatile,
    );
  }

  /// Creates a [SecureStow] to store encrypted integer values
  /// using [FlutterSecureStorage].
  ///
  /// This constructor automatically converts the integer value to a string
  /// using [IntToStringCodec] before storing it.
  ///
  /// If [Value] is not an integer, you must provide a codec that can convert
  /// the value to an integer, e.g. [EnumCodec] or [ColorCodec].
  @Deprecated('Use SecureStow.int instead.')
  factory SecureStow.numerical(
    String key,
    Value defaultValue, {
    Codec<Value, int?>? codec,
    bool volatile,
  }) = SecureStow.int;

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

    if (encodedValue == null || value == encodedDefaultValue) {
      await storage.delete(key: key);
    } else {
      await storage.write(key: key, value: encodedValue);
    }
  }

  @override
  String toString() => 'SecureStow<$Value>($key, $value, $codec)';
}
