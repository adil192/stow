import 'package:stow_codecs/stow_codecs.dart';

/// Encodes an integer by calling toString() on it.
class IntToStringCodec extends AbstractCodec<int, String> {
  const IntToStringCodec();

  @override
  String encode(int input) => input.toString();

  @override
  int decode(String encoded) => int.parse(encoded);
}
