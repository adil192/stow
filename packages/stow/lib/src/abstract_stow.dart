import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';

/// An abstract class that allows synchronous access to a value
/// from some asynchronous storage. Actual implementations may vary.
abstract class Stow<Key, Value, EncodedValue> extends ChangeNotifier
    implements ValueNotifier<Value> {
  Stow(this.key, this.defaultValue, {this.codec, bool autoRead = true}) {
    if (autoRead) unawaited(read());
    addListener(write);
  }

  /// A unique identifier for this stow.
  final Key key;

  /// The value to use if the underlying storage does not contain a value.
  final Value defaultValue;

  /// A codec to encode and decode the value to/from the underlying storage.
  /// If null, the value is assumed to be directly storable.
  /// Some implementations of [Stow] may not use this codec at all.
  final Codec<Value, EncodedValue>? codec;

  /// Whether [read] has been run at least once.
  bool get loaded => _loaded;
  bool _loaded = false;
  @visibleForTesting
  set loaded(bool loaded) {
    if (_loaded == loaded) return;
    _loaded = loaded;
    notifyListeners();
  }

  final _readMutex = Mutex();
  final _writeMutex = Mutex();

  @override
  Value get value => _value;
  late Value _value = defaultValue;
  @override
  set value(Value value) {
    if (_value == value) return;
    _value = value;
    // TODO: Maybe support different update strategies, like writing immediately, debounced, or only before dispose.
    notifyListeners();
  }

  /// Sets [value] without calling [notifyListeners].
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
    _loaded = true;
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

  /// Whether a read operation is currently in progress.
  /// Also see [waitUntilRead] and [loaded].
  bool get isReading => _readMutex.isLocked;

  /// Waits until the write mutex is unlocked.
  Future<void> waitUntilWritten() => _writeMutex.protect(() async {});

  /// Whether a write operation is currently in progress.
  /// Also see [waitUntilWritten].
  bool get isWriting => _writeMutex.isLocked;

  @override
  @mustBeOverridden
  String toString() =>
      'Stow<$Key, $Value, $EncodedValue>($key, $value, $codec)';
}
