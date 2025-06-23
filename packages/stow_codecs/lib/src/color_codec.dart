import 'dart:convert';
import 'dart:ui' show Color;

/// Encodes a [Color] as an ARGB32 integer.
class ColorCodec extends Codec<Color, Object?> {
  const ColorCodec();

  @override
  final encoder = const _ColorEncoder();
  @override
  final decoder = const _ColorDecoder();
}

class _ColorEncoder extends Converter<Color, Object?> {
  const _ColorEncoder();

  @override
  int convert(Color color) => color.toARGB32();
}

class _ColorDecoder extends Converter<Object?, Color> {
  const _ColorDecoder();

  @override
  Color convert(Object? input) {
    if (input is int) {
      return Color(input);
    }

    throw ArgumentError('Invalid color input: (${input.runtimeType}) $input');
  }
}
