import 'dart:convert';

/// A codec that does not change the input or output types.
/// It simply passes the data through unchanged.
class IdentityCodec<T> extends Codec<T, T> {
  const IdentityCodec();

  @override
  Converter<T, T> get encoder => _IdentityConverter<T>();

  @override
  Converter<T, T> get decoder => _IdentityConverter<T>();
}

class _IdentityConverter<T> extends Converter<T, T> {
  const _IdentityConverter();

  @override
  T convert(T input) => input;
}
