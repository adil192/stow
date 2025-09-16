import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:stow_codecs/stow_codecs.dart';

/// An abtract [Codec] whose [encode] and [decode] methods need to be
/// overridden.
///
/// This requires less boilerplate than extending [Codec] directly
/// since you don't need to define the [Converter] classes separately.
///
/// A simple example:
/// ```dart
/// class MyIntCodec extends AbstractCodec<int, String> {
///   const MyIntCodec();
///   @override String encode(int input) => input.toString();
///   @override int decode(String input) => int.parse(input);
/// }
/// ```
///
/// You may alternatively want to use [DelegateCodec] which accepts the encode
/// and decode functions as constructor parameters. It is slightly more concise
/// but cannot be made `const`.
abstract class AbstractCodec<S, T> extends Codec<S, T> {
  const AbstractCodec();

  /// Converts a value of type [S] to type [T].
  @override
  @mustBeOverridden
  T encode(S input);

  /// Converts a value of type [T] to type [S].
  @override
  @mustBeOverridden
  S decode(T input);

  @override
  Converter<S, T> get encoder => _DelegateConverter<S, T>(encode);

  @override
  Converter<T, S> get decoder => _DelegateConverter<T, S>(decode);
}

/// A [Converter] that delegates conversion to a provided function.
class _DelegateConverter<A, B> extends Converter<A, B> {
  const _DelegateConverter(this.delegate);

  final B Function(A) delegate;

  @override
  B convert(A input) => delegate(input);
}
