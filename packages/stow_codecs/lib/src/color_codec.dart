import 'dart:convert';
import 'dart:ui' show Color;

/// Encodes a [Color] as an ARGB32 integer.
class ColorCodec<Encoded extends Object> extends Codec<Color, Encoded> {
  ColorCodec()
    : assert(0 is Encoded, 'ColorCodec\'s Encoded type must accept an integer');

  @override
  final encoder = _ColorEncoder<Encoded>();
  @override
  final decoder = _ColorDecoder<Encoded>();
}

class _ColorEncoder<Encoded extends Object> extends Converter<Color, Encoded> {
  const _ColorEncoder();

  @override
  Encoded convert(Color color) => color.toARGB32() as Encoded;
}

class _ColorDecoder<Encoded extends Object> extends Converter<Encoded, Color> {
  const _ColorDecoder();

  @override
  Color convert(Object? input) {
    if (input is int) {
      return Color(input);
    }

    throw ArgumentError('Invalid color input: (${input.runtimeType}) $input');
  }
}
