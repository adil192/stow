import 'dart:convert';

import 'package:stow_codecs/stow_codecs.dart';

/// A [Codec] that delegates encoding and decoding to functions
/// provided to its constructor.
///
/// This is useful for creating simple codecs without needing to define
/// a full class and its converter classes.
///
/// A simple example:
/// ```dart
/// final myIntCodec = DelegateCodec<int, String>(
///   encode: (input) => input.toString(),
///   decode: (encoded) => int.parse(encoded),
/// );
/// ```
///
/// You may alternatively want to use [AbstractCodec] if you want to
/// define a class with instance methods for encoding and decoding.
/// The main advantage of [AbstractCodec] over [DelegateCodec] is that you
/// can make it `const`.
class DelegateCodec<S, T> extends AbstractCodec<S, T> {
  DelegateCodec({required T Function(S) encode, required S Function(T) decode})
    : encodeDelegate = encode,
      decodeDelegate = decode;

  final T Function(S) encodeDelegate;
  final S Function(T) decodeDelegate;

  @override
  T encode(S input) => encodeDelegate(input);

  @override
  S decode(T encoded) => decodeDelegate(encoded);
}
