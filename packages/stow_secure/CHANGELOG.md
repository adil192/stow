## 0.5.1

 - **FIX**: Prevent concurrent writes to fix values not being saved on Windows, thank you to @QubaB in [#1](https://github.com/adil192/stow/pull/1).
 - **FIX**: Fixed a typo causing the default value to be stored unnecessarily when using a codec, thank you to @QubaB in [#1](https://github.com/adil192/stow/pull/1).

## 0.5.0

> Note: This release has breaking changes.

 - **BREAKING** **REF**: protectedRead and protectedWrite are independent of codec.

## 0.4.0+1

 - **FIX**: don't disregard singletons as being equal to default value.

## 0.4.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: replace `autoRead` with `volatile`, which disables reads/writes.

## 0.3.0

> Note: This release has breaking changes.

 - **FEAT**: add SecureStow.bool constructor.
 - **BREAKING** **REF**: rename SecureStow.numerical to SecureStow.int.

## 0.2.0+1

> Note: This release has breaking changes.

 - **FEAT**: add Stow.isReading and Stow.isWriting.
 - **FEAT**: add Stow.loaded getter.
 - **BREAKING** **TWEAK**: don't throw if value is unset, just return defaultValue.

## 0.2.0

> Note: This release has breaking changes.

 - **BREAKING** **TWEAK**: delete from storage if default value.
 - **BREAKING** **FEAT**: add autoRead flag to disable read() on init, and make codec a named param.

## 0.1.1

 - **DOC**: Added more documentation, comments, and instructions

## 0.1.0

 - **FEAT**: add stow_secure.

