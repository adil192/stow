import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stow_plain/stow_plain.dart';

void main() {
  test('Singleton', () async {
    SharedPreferences.setMockInitialValues({});
    final stow = PlainStow.json(
      'singleton',
      _Singleton.defaultInstance,
      fromJson: (json) => _Singleton.fromJson(json as Map<String, dynamic>),
    );
    await stow.waitUntilRead();
    expect(stow.value.value, 0);

    stow.value.value = 42;
    stow.notifyListeners();
    await stow.waitUntilWritten();

    final storedValue = await stow.protectedRead();
    stow.value.value = 84; // Make sure the default value isn't returned
    expect(storedValue.value, 42);
  });
}

class _Singleton {
  _Singleton._();
  static final defaultInstance = _Singleton._();

  int value = 0;

  Map<String, dynamic> toJson() {
    return {'value': value};
  }

  factory _Singleton.fromJson(Map<String, dynamic> json) {
    final instance = _Singleton._();
    instance.value = json['value'] as int;
    return instance;
  }
}
