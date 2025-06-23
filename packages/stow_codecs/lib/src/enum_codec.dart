import 'dart:convert';

/// Encodes an enum value as its ([Enum.index]).
class EnumCodec<T extends Enum> extends Codec<T, Object?> {
  EnumCodec(this.values);

  /// All possible values of the enum type [T].
  final List<T> values;

  @override
  late final encoder = _EnumEncoder<T>();
  @override
  late final decoder = _EnumDecoder<T>(values);
}

class _EnumEncoder<T extends Enum> extends Converter<T, int> {
  const _EnumEncoder();

  @override
  int convert(T input) => input.index;
}

class _EnumDecoder<T extends Enum> extends Converter<Object?, T> {
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
