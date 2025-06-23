import 'dart:convert';

/// Encodes an integer by calling toString() on it.
class IntToStringCodec extends Codec<int?, String?> {
  const IntToStringCodec();

  @override
  final encoder = const _IntEncoder();
  @override
  final decoder = const _IntDecoder();
}

class _IntEncoder extends Converter<int?, String?> {
  const _IntEncoder();

  @override
  String? convert(int? input) => input?.toString();
}

class _IntDecoder extends Converter<String?, int?> {
  const _IntDecoder();

  @override
  int? convert(String? input) => int.tryParse(input ?? '');
}
