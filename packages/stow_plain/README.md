# stow_plain

A storage implementation for [Stow] using [shared_preferences].

A `Stow` stores one data value, and a `PlainStow` stores it in shared preferences.

Note that the values are stored as plaintext (not encrypted) and may be easily read off the device. If you need more security, see [stow_secure].

[![pub.dev](https://img.shields.io/pub/v/stow_plain.svg)][stow_plain]
[![License](https://img.shields.io/github/license/adil192/stow)][license]
[![maintained with melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

## Getting Started

Run the following in your flutter project:

```bash
flutter pub add stow_plain
flutter pub add stow_codecs # (optional)
```

And define the stows you want somewhere in your code:

```dart
final stows = Stows();

// Don't worry, this is explained below in the Stow definitions section.
class Stows {
  final count = PlainStow('count', 0);
  final darkMode = PlainStow('dark_mode', false);

  final gameState = PlainStow.json('game_state', GameState.empty(),
      fromJson: (json) => GameState.fromJson(json as Map<String, dynamic>));

  final favoriteColor = PlainStow('favorite_color', Colors.blue,
      codec: ColorCodec());

  final gameMode = PlainStow('game_mode', GameMode.easy,
      codec: GameMode.codec);
}
```

Then you can use the stows like this:

```dart
// If needed, wait for it to loaded from disk
await stows.darkMode.waitUntilRead();
// Get the value
print(stows.darkMode.value); // false
// Set the value
stows.darkMode.value = true; // triggers a write to disk
// If needed, wait for it to be written to disk
await stows.darkMode.waitUntilWritten();
```

And you can listen to changes:

```dart
// Manually listen to changes.
stows.darkMode.addListener(_someListenerFunction);
// Always remove the listener in the dispose method or when you're done.
stows.darkMode.removeListener(_someListenerFunction);

// Or use something like Flutter's ValueListenableBuilder
  child: ValueListenableBuilder(
    valueListenable: stows.darkMode,
    builder: (BuildContext context, bool darkMode, Widget? child) {
      return Switch(
        value: darkMode,
        onChanged: (value) {
          stows.darkMode.value = value; // triggers a write to disk and updates this widget
        },
      );
    },
  ),
```

## Stow definitions

You can define stows in any class/classes you want (they'll be loaded from disk when they're instantiated) but I like to organize them in a single class called `Stows`.

For each stow, you typically need to provide a key (used by [shared_preferences]) and a default value to be used when the value is unset.

For the PlainStow to know how to encode your data, you need to use the corresponding constructor
or codec.


### Simple types

For types already storable in [shared_preferences] (int, bool, double, String, List\<String\>, Set\<String\>), you can use the normal `PlainStow` constructor without needing a codec.

```dart
  final count = PlainStow.'count', 0);
  final darkMode = PlainStow.'dark_mode', false);
  final highScore = PlainStow.'high_score', 0.0);
  final lastName = PlainStow.'last_name', '');
  final middleNames = PlainStow('middle_names', <String>[]);
  // If needed, you can specify the stow type explicitly like this:
  final pets = PlainStow<Set<String>>('pets', {});
```

### JSON primitive values

For values supported by [jsonEncode] and [jsonDecode], you can use the `PlainStow.json` constructor.

```dart
  final someObject = PlainStow.json('some_object', {'key': 'value'});
```

### JSON compatible classes

For a json-serializable class, you can use the `PlainStow.json` by specifying a `fromJson` function.

The class should also have a `toJson` method that returns a primitive value (like a Map or List).

```dart
class Stows {
  final gameState = PlainStow.json('game_state', GameState.empty(),
      // This function converts a primitive (e.g. Map) to the desired Dart object.
      fromJson: (json) => GameState.fromJson(json as Map<String, dynamic>));
}

class GameState {
  Map<String, dynamic> toJson() => {'score': score, 'playerName': playerName};

  factory GameState.fromJson(Map<String, dynamic> json) =>
      GameState(json['score'], json['playerName']);

  //...
}
```

### Enums

For enums, you can use the `PlainStow` constructor with an `EnumCodec`.

```dart
class Stows {
  final gameMode = PlainStow('game_mode', GameMode.easy, codec: GameMode.codec);
}

enum GameMode {
  easy,
  medium,
  hard;

  static final codec = EnumCodec(values);
}
```

Or if you can't modify the enum, just create the EnumCodec inline:

```dart
  final targetPlatform = PlainStow('target_platform', kTargetPlatform,
      codec: EnumCodec(TargetPlatform.values));
```

### Other

For any other type, you can use the `PlainStow` constructor and provide a codec that converts
the value to and from a simple type that shared_preferences can handle.

```dart
  final favoriteColor = PlainStow('favorite_color', Colors.blue,
      codec: ColorCodec());
```

## Codecs

A codec encodes and decodes a value for easier storage.

For example, `ColorCodec` encodes a `Color` as an integer, and then decodes it back to a `Color`.

For convenience, some codecs are provided by the [stow_codecs] package,
but they're easy to write yourself.
Some of the codecs provided are:
- `ColorCodec` which encodes a `Color` as an integer.
- `EnumCodec` which encodes an enum value as its index.
- `IdentityCodec` which just returns its input as-is (typically we just pass `null` for the codec instead).
- `TypedJsonCodec` which `jsonEncode`s a value (used internally by `PlainStow.json`).

See
[`color_codec.dart`](https://github.com/adil192/stow/blob/main/packages/stow_codecs/lib/src/color_codec.dart)
and
[`enum_codec.dart`](https://github.com/adil192/stow/blob/main/packages/stow_codecs/lib/src/enum_codec.dart)
for examples of how to write your own codecs.





[stow]: https://pub.dev/packages/stow
[license]: https://github.com/adil192/stow/blob/main/LICENSE
[stow_codecs]: https://pub.dev/packages/stow_codecs
[stow_plain]: https://pub.dev/packages/stow_plain
[stow_secure]: https://pub.dev/packages/stow_secure
[shared_preferences]: https://pub.dev/packages/shared_preferences
