import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mutex/mutex.dart';
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
  Future<String?> protectedRead() async => storage.read(key: key);

  @override
  Future<void> protectedWrite(String? encodedValue) async {
    if (encodedValue == null || encodedValue == encodedDefaultValue) {
      await storage.delete(key: key);
    } else {
      await storage.write(key: key, value: encodedValue);
    }
  }

  @override
  String toString() => 'SecureStow<$Value>($key, $value, $codec)';

  @override
  @visibleForOverriding
  final writeMutex = _globalWriteMutex;

  /// flutter_secure_storage can only handle one write at a time,
  /// so we use one write mutex across all secure stows.
  static final _globalWriteMutex = Mutex();
}
