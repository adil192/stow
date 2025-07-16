import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stow_plain/stow_plain.dart';

void main() {
  test('Modifying the default value should still write', () async {
    SharedPreferences.setMockInitialValues({});
    final stow = PlainStow('stringList', <String>[]);
    await stow.waitUntilRead();
    expect(stow.value, <String>[]);
    expect(stow.encodedDefaultValue, <String>[]);

    stow.value.add('modified');
    stow.notifyListeners();
    await stow.waitUntilWritten();

    final storedValue = await stow.protectedRead();
    expect(
      storedValue,
      isNotNull,
      reason:
          'Value should be written even if "identical" to what was passed as defaultValue',
    );
  });
}
