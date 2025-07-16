import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stow_plain/stow_plain.dart';

void main() {
  test('Modifying the default value should still write', () async {
    SharedPreferences.setMockInitialValues({});
    final stow = PlainStow('stringList', <String>[]);
    await stow.waitUntilRead();
    expect(stow.value, <String>[]);

    stow.value.add('before_write');
    stow.notifyListeners();
    await stow.waitUntilWritten();
    final storedValue = await stow.protectedRead();

    // Modify the original so we can distinguish it from the stored value
    stow.value.add('after_write');

    expect(
      storedValue,
      isNot(equals(stow.value)),
      reason:
          'A non-null value should have been written, so protectedRead should not have returned the defaultValue',
    );
    expect(storedValue, <String>['before_write']);
  });
}
