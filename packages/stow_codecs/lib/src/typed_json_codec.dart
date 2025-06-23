import 'dart:convert';

/// A codec that wraps the standard [JsonCodec] to loosen its type constraints.
/// This allows us to use it with e.g. [PlainStow] more easily.
class TypedJsonCodec<T, Encoded extends Object?> extends Codec<T, Encoded> {
  TypedJsonCodec({this.fromJson, this.child = const JsonCodec()})
    : assert(
        '' is Encoded ||
            0 is Encoded ||
            0.0 is Encoded ||
            false is Encoded ||
            null is Encoded ||
            const {} is Encoded ||
            const [] is Encoded,
        'TypedJsonCodec\'s Encoded type must accept a JSON-encoded value.',
      );

  /// Takes the output of [jsonDecode] and parses it into a type [T].
  /// Usually this uses a constructor like `T.fromJson(json)`.
  ///
  /// If this function is not provided, the codec will simply return the
  /// decoded JSON object cast to [T].
  final T Function(Object json)? fromJson;
  final JsonCodec child;

  @override
  TypedJsonEncoder<T, Encoded> get encoder => TypedJsonEncoder(child.encoder);
  @override
  TypedJsonDecoder<Encoded, T> get decoder =>
      TypedJsonDecoder(fromJson, child.decoder);
}

class TypedJsonEncoder<T, Encoded extends Object?>
    extends Converter<T, Encoded> {
  const TypedJsonEncoder(this.child);

  final JsonEncoder child;

  @override
  Encoded convert(T input) => child.convert(input) as Encoded;
}

class TypedJsonDecoder<Encoded extends Object?, T>
    extends Converter<Encoded, T> {
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
