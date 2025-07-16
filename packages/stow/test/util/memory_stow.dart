import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stow/stow.dart';

/// A reference implementation of [Stow] that stores values in a dictionary
/// in memory.
class MemoryStow<Value> extends Stow<String, Value, Value> {
  MemoryStow(super.key, super.defaultValue, {super.volatile});

  static final _store = <String, dynamic>{};

  /// Reads the value from the dictionary store.
  @override
  @protected
  @visibleForTesting
  Future<Value> protectedRead() async {
    if (!_store.containsKey(key)) {
      printOnFailure('MemoryStow: Key $key not found, returning default value');
      return defaultValue;
    }
    printOnFailure('MemoryStow: Reading value for key $key');
    return _store[key] as Value;
  }

  /// Stores the [value] in the dictionary store.
  @override
  @protected
  @visibleForTesting
  Future<void> protectedWrite(Value? value) async {
    printOnFailure('MemoryStow: Writing value $value for key $key');
    if (value == null || value == defaultValue) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  @override
  String toString() => 'MemoryStow<$Value>($key, $value)';
}
