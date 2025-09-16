import 'package:stow_codecs/stow_codecs.dart';

/// A codec that does not change the input or output types.
/// It simply passes the data through unchanged.
class IdentityCodec<T> extends AbstractCodec<T, T> {
  const IdentityCodec();

  @override
  T encode(T input) => input;

  @override
  T decode(T encoded) => encoded;
}
