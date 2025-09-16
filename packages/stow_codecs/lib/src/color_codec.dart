import 'dart:ui' show Color;

import 'package:stow_codecs/stow_codecs.dart';

/// Encodes a [Color] as an ARGB32 integer.
class ColorCodec<Encoded extends Object> extends AbstractCodec<Color, Encoded> {
  ColorCodec()
    : assert(0 is Encoded, 'ColorCodec\'s Encoded type must accept an integer');

  @override
  Encoded encode(Color input) => input.toARGB32() as Encoded;

  @override
  Color decode(Encoded encoded) {
    if (encoded is int) {
      return Color(encoded);
    }

    throw ArgumentError(
      'Invalid color input: (${encoded.runtimeType}) $encoded',
    );
  }
}
