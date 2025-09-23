import 'dart:convert';

import 'package:stow_codecs/stow_codecs.dart';

/// A codec that wraps the standard [JsonCodec] to loosen its type constraints.
/// This allows us to use it with e.g. [PlainStow] more easily.
class TypedJsonCodec<T> extends AbstractCodec<T, String> {
  const TypedJsonCodec({this.fromJson});

  /// Takes the output of [jsonDecode] and parses it into a type [T].
  /// Usually this uses a constructor like `T.fromJson(json)`.
  ///
  /// If this function is not provided, the codec will simply return the
  /// decoded JSON object cast to [T].
  final T Function(Object json)? fromJson;

  static const parent = JsonCodec();

  @override
  String encode(T input) => parent.encode(input);

  @override
  T decode(String encoded) {
    final decoded = parent.decode(encoded);
    if (fromJson != null) {
      return fromJson!(decoded);
    } else {
      return decoded as T;
    }
  }
}
