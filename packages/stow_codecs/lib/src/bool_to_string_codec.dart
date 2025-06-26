import 'dart:convert';

class BoolToStringCodec extends Codec<bool, String> {
  const BoolToStringCodec();

  @override
  final encoder = const _BoolEncoder();
  @override
  final decoder = const _BoolDecoder();
}

class _BoolEncoder extends Converter<bool, String> {
  const _BoolEncoder();

  @override
  String convert(bool input) => input ? 'true' : 'false';
}

class _BoolDecoder extends Converter<String, bool> {
  const _BoolDecoder();

  @override
  bool convert(String input) {
    if (input == 'true') return true;
    if (input == 'false') return false;

    // More options to increase compatibility
    if (input == '1' || input.toLowerCase().startsWith('y')) return true;
    if (input == '0' || input.toLowerCase().startsWith('n')) return false;

    throw FormatException('Invalid boolean string: $input');
  }
}
