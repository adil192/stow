import 'package:flutter_test/flutter_test.dart';
import 'package:stow/stow.dart';

void main() {
  test('Loading a stow shouldn\'t induce a write', () async {
    Stow.volatileInTests = false;
    final stow = _CountingStow();
    await stow.waitUntilRead();
    expect(stow.readCount, 1, reason: 'Stow should be read once on load');
    expect(stow.writeCount, 0, reason: 'Stow should not write on load');
  });
}

class _CountingStow extends Stow {
  _CountingStow() : super('test_key', 'default_value');

  int readCount = 0;
  int writeCount = 0;

  @override
  Future protectedRead() async {
    readCount++;
    return '';
  }

  @override
  Future<void> protectedWrite(value) async {
    writeCount++;
    await null;
  }

  @override
  String toString() =>
      'CountingStow($readCount reads, $writeCount writes, value: $value)';
}
