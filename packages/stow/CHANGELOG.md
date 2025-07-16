## 0.5.0

> Note: This release has breaking changes.

 - **FIX**: loading a stow shouldn't induce a write.
 - **BREAKING** **REF**: protectedRead and protectedWrite are independent of codec.

## 0.4.0+1

 - **FIX**: don't disregard singletons as being equal to default value.

## 0.4.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: replace `autoRead` with `volatile`, which disables reads/writes.

## 0.3.1

- **TWEAK**: Stows will notify listeners when loaded
- **TWEAK**: Tests can now set `Stow.loaded`

## 0.3.0

> Note: This release has breaking changes.

 - **FEAT**: add Stow.isReading and Stow.isWriting.
 - **FEAT**: add Stow.loaded getter.
 - **BREAKING** **TWEAK**: don't throw if value is unset, just return defaultValue.

## 0.2.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: add autoRead flag to disable read() on init, and make codec a named param.

## 0.1.2

 - **DOC**: Fix missing example on pub.dev

## 0.1.1

 - **DOC**: Added more documentation, comments, and instructions

## 0.1.0

 - **FEAT**: add PlainStow for shared preferences.
 - **FEAT**: add Stow, MemoryStow, and IdentityCodec.

