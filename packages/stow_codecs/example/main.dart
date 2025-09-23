import 'package:flutter/material.dart';
import 'package:stow_codecs/stow_codecs.dart';

enum Pets {
  cat,
  dog,
  fish;

  static const codec = EnumCodec(values);
}

void main() {
  assert(Pets.codec.encode(Pets.cat) == Pets.cat.index);
  assert(Pets.codec.decode(Pets.dog.index) == Pets.dog);

  const colorCodec = ColorCodec();
  assert(colorCodec.encode(Colors.red) == Colors.red.toARGB32());
  assert(colorCodec.decode(Colors.blue.toARGB32()) == Colors.blue);
}
