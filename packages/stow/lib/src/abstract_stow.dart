import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';

abstract class Stow<Key, Value, EncodedValue> extends ChangeNotifier
    implements ValueNotifier<Value> {
  Stow(this.key, this.defaultValue, this.codec) {
    unawaited(read());
    addListener(write);
  }

  final Key key;
  final Value defaultValue;
  final Codec<Value, EncodedValue>? codec;
  Value? _value;

  final _readMutex = Mutex();
  final _writeMutex = Mutex();

  @override
  Value get value {
    if (_value is! Value) {
      // i.e. if value is null and [Value] is not nullable
      throw StateError('Value has not been initialized yet.');
    }
    return _value as Value;
  }

  @override
  set value(Value value) {
    if (_value == value) return;
    _value = value;
    // TODO: Maybe support different update strategies, like writing immediately, debounced, or only before dispose.
    notifyListeners();
  }

  @protected
  @visibleForTesting
  void setValueWithoutNotifying(Value value) {
    _value = value;
  }

  @override
  void notifyListeners() => super.notifyListeners();

  /// Reads from the underlying storage and sets [value].
  @visibleForTesting
  Future<void> read() => _readMutex.protect(() async {
    final newValue = await protectedRead();
    setValueWithoutNotifying(newValue);
    // TODO(adil192): Maybe notify but don't write?
  });

  /// Writes the current [value] to the underlying storage.
  ///
  /// This is called automatically when the value changes.
  /// If you need to set the value without writing it, use
  /// [setValueWithoutNotifying].
  /// Conversely, if you need to manually trigger a write,
  /// use [notifyListeners].
  @visibleForTesting
  Future<void> write() => _writeMutex.protect(() async {
    await protectedWrite(value);
  });

  /// Reads from the underlying storage and returns a value if found
  /// or the [defaultValue] otherwise.
  @protected
  @mustBeOverridden
  @visibleForTesting
  Future<Value> protectedRead();

  /// Writes a [value] to the underlying storage.
  @protected
  @mustBeOverridden
  @visibleForTesting
  Future<void> protectedWrite(Value value);

  /// Waits until the read mutex is unlocked.
  Future<void> waitUntilRead() => _readMutex.protect(() async {});

  /// Waits until the write mutex is unlocked.
  Future<void> waitUntilWritten() => _writeMutex.protect(() async {});
}
