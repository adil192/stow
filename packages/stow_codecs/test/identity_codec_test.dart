import 'package:flutter_test/flutter_test.dart';
import 'package:stow_codecs/stow_codecs.dart';

void main() {
  group('IdentityCodec', () {
    test('<String>', () {
      final codec = IdentityCodec<String>();
      const value = 'Hello, World!';
      expect(codec.encode(value), value);
      expect(codec.decode(value), value);
    });

    test('<Null>', () {
      final codec = IdentityCodec<Null>();
      expect(codec.encode(null), null);
      expect(codec.decode(null), null);
    });

    test('<dynamic>', () {
      final codec = IdentityCodec<dynamic>();
      for (final value in [0, 1.5, true, 'Hello', null]) {
        expect(codec.encode(value), value);
        expect(codec.decode(value), value);
      }
    });
  });
}
