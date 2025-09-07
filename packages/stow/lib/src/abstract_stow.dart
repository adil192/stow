import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' hide Key;
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';

/// An abstract class that allows synchronous access to a value
/// from some asynchronous storage. Actual implementations may vary.
abstract class Stow<Key, Value, EncodedValue> extends ChangeNotifier
    implements ValueNotifier<Value> {
  Stow(this.key, this.defaultValue, {this.codec, this.volatile = false}) {
    encodedDefaultValue = encode(defaultValue);
    unawaited(read());
    addListener(write);
  }

  /// A unique identifier for this stow.
  final Key key;

  /// The value to use if the underlying storage does not contain a value.
  final Value defaultValue;

  /// The default value after being encoded with the [codec].
  /// If no codec is provided, this is the same as [defaultValue].
  late final EncodedValue? encodedDefaultValue;

  /// A codec to encode and decode the value to/from the underlying storage.
  /// If null, the value is assumed to be directly storable.
  /// Some implementations of [Stow] may not use this codec at all.
  final Codec<Value, EncodedValue>? codec;

  /// If [volatile] is true, [read] and [write] will be disabled
  /// meaning nothing gets stored or read.
  ///
  /// This is useful in testing environments or to avoid platform channel
  /// issues with secondary isolates.
  final bool volatile;

  /// Whether [read] has been run at least once.
  bool get loaded => _loaded;
  bool _loaded = false;
  @visibleForTesting
  set loaded(bool loaded) {
    if (_loaded == loaded) return;
    _loaded = loaded;
    notifyListeners();
  }

  @visibleForOverriding
  final readMutex = Mutex();
  @visibleForOverriding
  final writeMutex = Mutex();

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

  /// The last value read from the underlying storage,
  /// used so we don't write it again if [notifyListeners] gets called.
  EncodedValue? _lastReadValue;

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
  Future<void> read() => readMutex.protect(() async {
    if (volatile) {
      loaded = true;
      return;
    }

    _lastReadValue = await protectedRead();
    _loaded = true;
    value = decode(_lastReadValue) ?? defaultValue;
  });

  /// Writes the current [value] to the underlying storage.
  ///
  /// This is called automatically when the value changes.
  /// If you need to set the value without writing it, use
  /// [setValueWithoutNotifying].
  /// Conversely, if you need to manually trigger a write,
  /// use [notifyListeners].
  @visibleForTesting
  Future<void> write() => writeMutex.protect(() async {
    if (volatile) return;

    final encodedValue = encode(value);
    if (encodedValue == _lastReadValue) return;

    await protectedWrite(encodedValue);
    _lastReadValue = encodedValue;
  });

  /// Reads from the underlying storage and returns a value if found.
  @protected
  @visibleForTesting
  Future<EncodedValue?> protectedRead();

  /// Writes a [value] to the underlying storage.
  @protected
  @visibleForTesting
  Future<void> protectedWrite(EncodedValue? value);

  @protected
  @visibleForTesting
  EncodedValue? encode(Value? value) {
    if (codec == null) return value as EncodedValue?;
    if (value == null) return null;
    return codec!.encode(value);
  }

  @protected
  @visibleForTesting
  Value? decode(EncodedValue? encodedValue) {
    if (codec == null) return encodedValue as Value?;
    if (encodedValue == null) return null;
    return codec!.decode(encodedValue);
  }

  /// Waits until the read mutex is unlocked.
  Future<void> waitUntilRead() => readMutex.protect(() async {});

  /// Whether a read operation is currently in progress.
  /// Also see [waitUntilRead] and [loaded].
  bool get isReading => readMutex.isLocked;

  /// Waits until the write mutex is unlocked.
  Future<void> waitUntilWritten() => writeMutex.protect(() async {});

  /// Whether a write operation is currently in progress.
  /// Also see [waitUntilWritten].
  bool get isWriting => writeMutex.isLocked;

  @override
  @mustBeOverridden
  String toString() =>
      'Stow<$Key, $Value, $EncodedValue>($key, $value, $codec)';
}
