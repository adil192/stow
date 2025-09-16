# stow_codecs

A collection of codecs and utilities commonly used with [stow][stow] packages
like [stow_plain][stow_plain].

[![pub.dev](https://img.shields.io/pub/v/stow_codecs.svg)][stow_codecs]
[![License](https://img.shields.io/github/license/adil192/stow)][license]
[![maintained with melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

[stow]: https://pub.dev/packages/stow
[license]: https://github.com/adil192/stow/blob/main/LICENSE
[stow_codecs]: https://pub.dev/packages/stow_codecs
[stow_plain]: https://pub.dev/packages/stow_plain

## Custom codecs

If you need to write your own codec, it may be easier/quicker to use these
utility classes instead of the base `Codec` class from `dart:convert`...

### `AbstractCodec`

An abstract codec whose encode and decode methods need to be overridden.

This requires less boilerplate than extending `Codec` directly
since you don't need to define the `Converter` classes separately.

A simple example (identical to `IntToStringCodec` below):
```
class MyIntCodec extends AbstractCodec<int, String> {
  const MyIntCodec();
  @override String encode(int input) => input.toString();
  @override int decode(String input) => int.parse(input);
}
```

### `DelegateCodec`

A codec that delegates encoding and decoding to the functions
provided to its constructor.

Compared to `AbstractCodec`, a `DelegateCodec` definition can be more concise
and can even be defined inline since you don't need to write a class.
However, since its constructor takes functions, it cannot be made `const`.

A simple example (identical to `IntToStringCodec` below except not `const`):
```dart
final myIntCodec = DelegateCodec<int, String>(
  encode: (input) => input.toString(),
  decode: (encoded) => int.parse(encoded),
);
```

## Ready-made codecs

We also have a few codecs that are ready to use without any extra code...

### `BoolToStringCodec`

Converts between `bool` and `String` types,
e.g. `true` <-> `'true'`.

Usage: `const BoolToStringCodec()`.

### `ColorCodec`

Encodes a `Color` as an ARGB32 integer,
e.g. `Color(0xFF123456)` <-> `0xFF123456`.

Usage: `const ColorCodec()`.

### `EnumCodec`

Encodes an enum value as its index,
e.g. `Fruits.banana` <-> `1`.

Usage:
```dart
enum Fruits {
  apple, banana, cherry;

  // Define it directly in the enum...
  static final codec = EnumCodec(values);
}
// ...or outside the enum...
final codec = EnumCodec(Fruits.values);
```

### `IdentityCodec`

Does nothing to its input.

Usage: `const IdentityCodec()`

### `IntToStringCodec`

Converts between `int` and `String` types,
e.g. `123` <-> `'123'`.

Usage: `const IntToStringCodec()`.

### `TypedJsonCodec`

The same as Dart's built-in `JsonCodec` but with loosened type constraints.

Typically, you would not use this directly. It is internally used in
[stow_plain][stow_plain]'s `PlainStow.json` constructor.
