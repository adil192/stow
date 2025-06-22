import 'dart:convert';

/// A codec that wraps the standard [JsonCodec] to loosen its type constraints.
/// This allows us to use it with e.g. [PlainStow] more easily.
class TypedJsonCodec<T> extends Codec<T, Object?> {
  TypedJsonCodec({this.fromJson, this.child = const JsonCodec()});

  /// Takes the output of [jsonDecode] and parses it into a type [T].
  /// Usually this uses a constructor like `T.fromJson(json)`.
  ///
  /// If this function is not provided, the codec will simply return the
  /// decoded JSON object cast to [T].
  final T Function(Object json)? fromJson;
  final JsonCodec child;

  @override
  TypedJsonDecoder<T> get decoder => TypedJsonDecoder(fromJson, child.decoder);
  @override
  TypedJsonEncoder<T> get encoder => TypedJsonEncoder(child.encoder);
}

class TypedJsonDecoder<T> extends Converter<Object?, T> {
  const TypedJsonDecoder(this.parser, this.child);

  final T Function(Object json)? parser;
  final JsonDecoder child;

  @override
  T convert(Object? input) {
    if (input is! String) {
      throw ArgumentError(
        'JsonDecoder expects a String but got: ${input.runtimeType}',
      );
    }

    final decoded = child.convert(input);

    if (parser != null) {
      return parser!(decoded);
    } else {
      return decoded as T;
    }
  }
}

class TypedJsonEncoder<T> extends Converter<T, Object?> {
  const TypedJsonEncoder(this.child);

  final JsonEncoder child;

  @override
  Object? convert(T input) => child.convert(input);
}
