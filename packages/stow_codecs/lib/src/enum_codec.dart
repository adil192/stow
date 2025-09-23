import 'package:stow_codecs/stow_codecs.dart';

/// Encodes an enum value as its ([Enum.index]).
class EnumCodec<T extends Enum> extends AbstractCodec<T, int> {
  const EnumCodec(this.values);

  /// All possible values of the enum type [T].
  ///
  /// This is equivalent to the static `T.values` field that is
  /// automatically generated for every enum type.
  final List<T> values;

  @override
  int encode(T input) => input.index;

  @override
  T decode(int encoded) => values[encoded];
}
