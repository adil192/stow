## 0.5.1

 - **FIX**: Lists should be growable (resizeable) after being read

## 0.5.0

> Note: This release has breaking changes.

 - **FIX**: clone encodedDefaultValue with identity codec.
 - **BREAKING** **REF**: protectedRead and protectedWrite are independent of codec.

## 0.4.0+1

 - **FIX**: don't disregard singletons as being equal to default value.

## 0.4.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: replace `autoRead` with `volatile` which disables reads/writes.

## 0.2.1+3

 - **FIX**: codecs don't need nullable args.
   As a side effect, codecs can no longer remap null values.

## 0.2.1+2

 - **FIX**: cast error with string lists.

## 0.2.1+1

 - Update a dependency to the latest release.

## 0.2.1

 - **FEAT**: support Set<String> without codec.

## 0.2.0+1

> Note: This release has breaking changes.

 - **FEAT**: add Stow.isReading and Stow.isWriting.
 - **FEAT**: add Stow.loaded getter.
 - **BREAKING** **TWEAK**: don't throw if value is unset, just return defaultValue.

## 0.2.0

> Note: This release has breaking changes.

 - **BREAKING** **TWEAK**: delete from storage if default value.
 - **BREAKING** **REF**: use `PlainStow()` instead of `PlainStow.simple()`.
 - **BREAKING** **FEAT**: add autoRead flag to disable read() on init, and make codec a named param.

## 0.1.2

 - **DOC**: Fix missing example on pub.dev

## 0.1.1

 - **DOC**: Added more documentation, comments, and instructions

## 0.1.0

 - **FEAT**: add EnumCodec.
 - **FEAT**: add ColorCodec.
 - **FEAT**: add PlainStow.json.
 - **FEAT**: add PlainStow for shared preferences.

