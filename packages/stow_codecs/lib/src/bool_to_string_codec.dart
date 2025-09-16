import 'package:stow_codecs/stow_codecs.dart';

class BoolToStringCodec extends AbstractCodec<bool, String> {
  const BoolToStringCodec();

  @override
  String encode(bool input) => input ? 'true' : 'false';

  @override
  bool decode(String encoded) {
    if (encoded == 'true') return true;
    if (encoded == 'false') return false;

    // More options to increase compatibility
    if (encoded == '1' || encoded.toLowerCase().startsWith('y')) return true;
    if (encoded == '0' || encoded.toLowerCase().startsWith('n')) return false;

    throw FormatException('Invalid boolean string: $encoded');
  }
}
