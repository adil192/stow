import 'dart:convert';

/// Encodes an enum value as its ([Enum.index]).
class EnumCodec<T extends Enum, Encoded extends Object?>
    extends Codec<T, Encoded> {
  EnumCodec(this.values)
    : assert(0 is Encoded, 'EnumCodec\'s Encoded type must accept an integer');

  /// All possible values of the enum type [T].
  final List<T> values;

  @override
  late final encoder = _EnumEncoder<T, Encoded>();
  @override
  late final decoder = _EnumDecoder<T, Encoded>(values);
}

class _EnumEncoder<T extends Enum, Encoded extends Object?>
    extends Converter<T, Encoded> {
  const _EnumEncoder();

  @override
  Encoded convert(T input) => input.index as Encoded;
}

class _EnumDecoder<T extends Enum, Encoded extends Object?>
    extends Converter<Encoded, T> {
  const _EnumDecoder(this.values);

  /// All possible values of the enum type [T].
  final List<T> values;

  @override
  T convert(Object? input) {
    if (input is int && input >= 0 && input < values.length) {
      return values[input];
    }
    throw ArgumentError('Invalid $T enum index: (${input.runtimeType}) $input');
  }
}
