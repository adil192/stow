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
  /// This constructor supports any codec but is more verbose than the
  /// other constructors.
  ///
  /// See also:
  /// - [PlainStow.simple] for storing simple values.
  /// - [PlainStow.json] for storing JSON-encodable values.
  PlainStow(super.key, super.defaultValue, {super.codec, super.autoRead})
    : assert(key.isNotEmpty);

  /// Creates a [PlainStow] to store unencrypted simple values
  /// using shared preferences.
  ///
  /// This constructor only supports simple types that are directly
  /// supported by shared_preferences: `int`, `bool`, `double`, `String`,
  /// and `List<String>`.
  ///
  /// See also:
  /// - [PlainStow.json] for storing JSON-encodable values.
  /// - [PlainStow.new] for storing arbitrary values with a custom codec.
  PlainStow.simple(super.key, super.defaultValue, {super.autoRead})
    : assert(key.isNotEmpty),
      assert(
        // This is the best we can do to assert simple types, but some edge
        // cases fall through. They will still fail at runtime.
        0 is Value ||
            false is Value ||
            0.0 is Value ||
            '' is Value ||
            <String>[] is Value,
        'PlainStow.simple only supports int, bool, double, String, List<String>.',
      );

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
  /// - [PlainStow.simple] for storing simple values.
  /// - [PlainStow.new] for storing arbitrary values with a custom codec.
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

    return codec == null ? encodedValue as Value : codec!.decode(encodedValue);
  }

  @override
  Future<void> protectedWrite(Value value) async {
    final encodedValue = codec == null ? value : codec!.encode(value);

    final prefs = await SharedPreferences.getInstance();
    if (encodedValue == null) {
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
