import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stow/stow.dart';
import 'package:stow_codecs/stow_codecs.dart';

/// A [Stow] implementation that stores plaintext (unencrypted) values with
/// shared preferences.
class PlainStow<Value> extends Stow<String, Value, Object?> {
  /// Creates a [PlainStow] to store unencrypted values
  /// using shared preferences.
  ///
  /// The [codec] must not be null, unless your [Value] type is one of the
  /// simple types that are directly storable in shared_preferences:
  /// `int`, `bool`, `double`, `String`, `List<String>`, or `Set<String>`.
  ///
  /// See also:
  /// - [PlainStow.json] for storing JSON-encodable values.
  PlainStow(super.key, super.defaultValue, {super.codec, super.autoRead})
    : assert(key.isNotEmpty),
      assert(
        codec != null || isSimpleType<Value>(),
        'Without a codec, only simple types are supported: '
        'int, bool, double, String, List<String>, or Set<String>.',
      );

  /// Creates a [PlainStow] to store unencrypted simple values
  /// using shared preferences.
  ///
  /// This constructor only supports simple types that are directly
  /// storable in shared_preferences: `int`, `bool`, `double`, `String`,
  /// `List<String>`, or `Set<String>`.
  ///
  /// See also:
  /// - [PlainStow.json] for storing JSON-encodable values.
  /// - [PlainStow.new] for storing arbitrary values with a custom codec.
  @Deprecated('Use PlainStow.new instead with a null codec')
  PlainStow.simple(super.key, super.defaultValue, {super.autoRead})
    : assert(key.isNotEmpty),
      assert(
        isSimpleType<Value>(),
        'PlainStow.simple only supports int, bool, double, String, List<String>, or Set<String>.',
      );

  /// This is the best we can do to assert simple types, but some edge
  /// cases fall through. They will still fail at runtime.
  static bool isSimpleType<Value>() =>
      0 is Value ||
      false is Value ||
      0.0 is Value ||
      '' is Value ||
      <String>[] is Value ||
      <String>{} is Value;

  /// Creates a [PlainStow] to store unencrypted json-encodable values
  /// using shared preferences.
  ///
  /// The [Value] type must be JSON-encodable or you will get a runtime error.
  ///
  /// If [Value] is not a primitive json type, you can provide a [fromJson]
  /// function that takes the output of [jsonDecode] and parses it into [Value]:
  /// typically, this is a constructor like `Value.fromJson(json)`.
  ///
  /// See also:
  /// - [PlainStow.new] for storing non-json values.
  PlainStow.json(
    super.key,
    super.defaultValue, {
    Value Function(Object json)? fromJson,
    bool autoRead = true,
  }) : assert(key.isNotEmpty),
       super(codec: TypedJsonCodec(fromJson: fromJson));

  @override
  Future<Value> protectedRead() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedValue = prefs.get(key);
    if (encodedValue == null) return defaultValue;

    final decodedValue = codec == null
        ? encodedValue
        : codec!.decode(encodedValue);

    if (Value == _typeOf<Set<String>>()) {
      // Convert List<dynamic> to Set<String>
      return (decodedValue as List<dynamic>).cast<String>().toSet() as Value;
    } else if (Value == _typeOf<List<String>>()) {
      // Convert List<dynamic> to List<String>
      return (decodedValue as List<dynamic>).cast<String>() as Value;
    } else {
      return decodedValue as Value;
    }
  }

  Object? _encode(Value value) {
    if (codec == null) return value;
    if (value == null) return null;
    return codec!.encode(value);
  }

  @override
  Future<void> protectedWrite(Value value) async {
    final encodedValue = _encode(value);

    final prefs = await SharedPreferences.getInstance();
    if (encodedValue == null || value == defaultValue) {
      await prefs.remove(key);
    } else if (encodedValue is int) {
      await prefs.setInt(key, encodedValue);
    } else if (encodedValue is bool) {
      await prefs.setBool(key, encodedValue);
    } else if (encodedValue is double) {
      await prefs.setDouble(key, encodedValue);
    } else if (encodedValue is String) {
      await prefs.setString(key, encodedValue);
    } else if (encodedValue is List<String>) {
      await prefs.setStringList(key, encodedValue);
    } else if (encodedValue is Iterable<String>) {
      await prefs.setStringList(key, encodedValue.toList(growable: false));
    } else {
      throw ArgumentError(
        'Tried to write unsupported type to $this: ${encodedValue.runtimeType}',
      );
    }
  }

  @override
  String toString() {
    return 'PlainStow<$Value>($key, $value, $codec)';
  }
}

Type _typeOf<T>() => T;
