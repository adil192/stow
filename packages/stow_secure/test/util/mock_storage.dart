import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final Map<String, String> _mockSecureStorage = <String, String>{};
void setupMockFlutterSecureStorage() {
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
        if (methodCall.method == 'delete') {
          _mockSecureStorage.remove(methodCall.arguments['key'] as String);
        } else if (methodCall.method == 'write') {
          _mockSecureStorage[methodCall.arguments['key'] as String] =
              methodCall.arguments['value'] as String;
        } else if (methodCall.method == 'read') {
          return _mockSecureStorage[methodCall.arguments['key'] as String];
        }
        return null;
      });
}
