import 'package:flutter/foundation.dart';
import 'package:stow/stow.dart';
import 'package:stow_codecs/stow_codecs.dart';

/// A reference implementation of [Stow] that stores values in a dictionary
/// in memory.
abstract class MemoryStow<Value> extends Stow<String, Value, Value> {
  MemoryStow(String key, Value defaultValue)
    : super(key, defaultValue, IdentityCodec<Value>());

  static final _store = <String, dynamic>{};

  /// Reads the value from the dictionary store.
  @override
  @protected
  Future<Value> protectedRead() async {
    // If the value is not found, return the default value.
    if (!_store.containsKey(key)) {
      return defaultValue;
    }
    // Return the value from the store.
    return _store[key] as Value;
  }

  /// Stores the [value] in the dictionary store.
  @override
  @protected
  Future<void> protectedWrite(Value value) async {
    _store[key] = value;
  }
}
