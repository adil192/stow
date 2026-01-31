# Stow

An abstraction to allow synchronous access to persistent data.

[![pub package](https://img.shields.io/pub/v/stow.svg)][stow]
[![GitHub license](https://img.shields.io/github/license/adil192/stow)][license]

This `stow` package holds some shared code for other packages in the Stow ecosystem.
It does not provide any functionality on its own.

## Stow packages

These packages store data in plaintext or encrypted form, using different storage backends. Follow the links for more information.

- [stow_plain]: A Stow package to store plaintext data in shared preferences.
- [stow_secure]: A Stow package to store encrypted data in secure storage.

Since storage backends including shared preferences and secure storage only accept certain data types, stows use codecs to convert between the value type and the encoded type. We use codecs a lot so naturally we provide some common ones and make it easy to create your own:

- [stow_codecs]: A package providing common codecs and utilities to create your own.

## Making your own Stow package

Creating a Stow implementation is easy.

Here's a basic example that stores data in an imaginary storage backend called `MyStorage`.

```dart
class MyStorageStow<MyValue> extends Stow<MyKey, MyValue, MyEncodedValue> {
  MyStorageStow(super.key, super.defaultValue);

  static final _myStorage = MyStorage();

  @override
  Future<MyEncodedValue?> protectedRead() async {
    return _myStorage.get<MyEncodedValue>(key);
  }

  @override
  Future<void> protectedWrite(MyEncodedValue? encodedValue) async {
    if (encodedValue == null || encodedValue == encodedDefaultValue) {
      await _myStorage.remove(key);
    } else {
      await _myStorage.set<MyEncodedValue>(key, encodedValue);
    }
  }
}
```

You can instantiate a stow like this, providing a key and a default value:

```dart
final darkMode = MyStorageStow<bool>('darkMode', false);
```

Then you can use the stows like this:

```dart
// If needed, wait for it to loaded from disk
await darkMode.waitUntilRead();
// Get the value
print(darkMode.value); // false
// Set the value
darkMode.value = true; // triggers a write to disk
// If needed, wait for it to be written to disk
await darkMode.waitUntilWritten();
```

And you can listen to changes:

```dart
// Manually listen to changes.
darkMode.addListener(_someListenerFunction);
// Always remove the listener in the dispose method or when you're done.
darkMode.removeListener(_someListenerFunction);

// Or use something like Flutter's ValueListenableBuilder
  child: ValueListenableBuilder(
    valueListenable: darkMode,
    builder: (BuildContext context, bool darkMode, Widget? child) {
      return Switch(
        value: darkMode,
        onChanged: (value) {
          darkMode.value = value; // triggers a write to disk and updates this widget
        },
      );
    },
  ),
```

[stow]: https://pub.dev/packages/stow
[license]: https://github.com/adil192/stow/blob/main/LICENSE
[stow_plain]: https://pub.dev/packages/stow_plain
[stow_secure]: https://pub.dev/packages/stow_secure
[stow_codecs]: https://pub.dev/packages/stow_codecs
