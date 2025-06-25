# stow_secure

A storage implementation for [Stow] using [flutter_secure_storage].

A `Stow` stores one data value, and a `SecureStow` stores it in secure storage.

Note that the values are stored encrypted and have a small performance penalty
compared to [stow_plain].

[![pub.dev](https://img.shields.io/pub/v/stow_secure.svg)][stow_secure]
[![License](https://img.shields.io/github/license/adil192/stow)][license]
[![maintained with melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

## Getting Started

Run the following in your flutter project:

```bash
flutter pub add stow_secure
flutter pub add stow_codecs # (optional)
```

And define the stows you want somewhere in your code:
(Don't worry, this is explained below in the [Stow definitions](#stow-definitions) section.)

```dart
final stows = Stows();

// Don't worry, this is explained below in the Stow definitions section.
class Stows {
  final username = SecureStow('username', '');
  final secretColor = SecureStow('secret_color', Colors.red,
      codec: ColorCodec());
}
```

And also make sure to follow
[flutter_secure_storage's instructions][flutter_secure_storage]
to set up secure storage in your app.

Then you can use the stows like this:

```dart
// If needed, wait for it to loaded from disk
await stows.username.waitUntilRead();
// Get the value
print(stows.username.value); // false
// Set the value
stows.username.value = 'johndoe'; // triggers a write to disk
// If needed, wait for it to be written to disk
await stows.username.waitUntilWritten();
```

And you can listen to changes:

```dart
// Manually listen to changes.
stows.username.addListener(_someListenerFunction);
// Always remove the listener in the dispose method or when you're done.
stows.username.removeListener(_someListenerFunction);

// Or use something like Flutter's ValueListenableBuilder
  child: ValueListenableBuilder(
    valueListenable: stows.username,
    builder: (BuildContext context, String username, Widget? child) {
      return Text('Username: $username');
    },
  ),
```

## Stow definitions

You can define stows in any class/classes you want (they'll be loaded from disk when they're instantiated) but I like to organize them in a single class called `Stows`.

For each stow, you typically need to provide a key (used by [flutter_secure_storage]) and a default value to be used when the value is unset.

For the SecureStow to know how to encode your data, you need to use the corresponding constructor
or codec:
- For string values, you can just use e.g. `SecureStow('key', 'some_default_value')`.
- For integer values, you can use `SecureStow.numerical('key', 0)`.
- For other values, find or make a codec that converts your data to a string/integer and use the relevant constructor e.g.:
  - `SecureStow('key', 'default', ValueToStringCodec())`
  - `SecureStow.numerical('key', 0, ColorCodec())`

## More information

Codecs and stow definitions are explained in more detail in the [stow_plain](https://pub.dev/packages/stow_plain) package documentation.


[stow]: https://pub.dev/packages/stow
[license]: https://github.com/adil192/stow/blob/main/LICENSE
[stow_plain]: https://pub.dev/packages/stow_plain
[stow_secure]: https://pub.dev/packages/stow_secure
[flutter_secure_storage]: https://pub.dev/packages/flutter_secure_storage