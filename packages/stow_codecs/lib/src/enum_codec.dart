import 'package:stow_codecs/stow_codecs.dart';

/// Encodes an enum value as its ([Enum.index]).
class EnumCodec<T extends Enum, Encoded extends Object?>
    extends AbstractCodec<T, Encoded> {
  EnumCodec(this.values)
    : assert(0 is Encoded, 'EnumCodec\'s Encoded type must accept an integer');

  /// All possible values of the enum type [T].
  final List<T> values;

  @override
  Encoded encode(T input) => input.index as Encoded;

  @override
  T decode(Object? encoded) {
    if (encoded is int && encoded >= 0 && encoded < values.length) {
      return values[encoded];
    }
    throw ArgumentError(
      'Invalid $T enum index: (${encoded.runtimeType}) $encoded',
    );
  }
}
