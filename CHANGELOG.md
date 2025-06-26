# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-06-26

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`stow_plain` - `v0.2.1`](#stow_plain---v021)

---

#### `stow_plain` - `v0.2.1`

 - **FEAT**: support Set<String> without codec.


## 2025-06-26

### Changes

---

Packages with breaking changes:

 - [`stow` - `v0.3.0`](#stow---v030)

Packages with other changes:

 - [`stow_plain` - `v0.2.0+1`](#stow_plain---v0201)
 - [`stow_secure` - `v0.2.0+1`](#stow_secure---v0201)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `stow_plain` - `v0.2.0+1`
 - `stow_secure` - `v0.2.0+1`

---

#### `stow` - `v0.3.0`

 - **FEAT**: add Stow.isReading and Stow.isWriting.
 - **FEAT**: add Stow.loaded getter.
 - **BREAKING** **TWEAK**: don't throw if value is unset, just return defaultValue.


## 2025-06-25

### Changes

---

Packages with breaking changes:

 - [`stow` - `v0.2.0`](#stow---v020)
 - [`stow_plain` - `v0.2.0`](#stow_plain---v020)
 - [`stow_secure` - `v0.2.0`](#stow_secure---v020)

Packages with other changes:

 - [`stow_codecs` - `v1.1.1`](#stow_codecs---v111)

---

#### `stow` - `v0.2.0`

 - **BREAKING** **FEAT**: add autoRead flag to disable read() on init, and make codec a named param.

#### `stow_plain` - `v0.2.0`

 - **BREAKING** **TWEAK**: delete from storage if default value.
 - **BREAKING** **REF**: use `PlainStow()` instead of `PlainStow.simple()`.
 - **BREAKING** **FEAT**: add autoRead flag to disable read() on init, and make codec a named param.

#### `stow_secure` - `v0.2.0`

 - **BREAKING** **TWEAK**: delete from storage if default value.
 - **BREAKING** **FEAT**: add autoRead flag to disable read() on init, and make codec a named param.

#### `stow_codecs` - `v1.1.1`

 - **FIX**: pub.dev complaining about no flutter dependency for stow_codecs.


## 2025-06-23

### Changes

---

Packages with breaking changes:

 - [`stow_codecs` - `v1.1.0`](#stow_codecs---v110)

Packages with other changes:

 - [`stow` - `v0.1.1`](#stow---v011)
 - [`stow` - `v0.1.2`](#stow---v012)
 - [`stow_plain` - `v0.1.1`](#stow_plain---v011)
 - [`stow_plain` - `v0.1.2`](#stow_plain---v012)
 - [`stow_secure` - `v0.1.0`](#stow_secure---v010)
 - [`stow_secure` - `v0.1.1`](#stow_secure---v011)

---

#### `stow_codecs` - `v1.1.0`

 - **FEAT**: add IntToStringCodec.
 - **BREAKING** **REF**: codecs now have generic output types.

---

#### `stow` - `v0.1.1`

 - **DOC**: Added more documentation, comments, and instructions

---

#### `stow` - `v0.1.2`

 - **DOC**: Fix missing example on pub.dev

---

#### `stow_plain` - `v0.1.1`

 - **DOC**: Added more documentation, comments, and instructions

---

#### `stow_plain` - `v0.1.2`

 - **DOC**: Fix missing example on pub.dev

---

#### `stow_secure` - `v0.1.0`

 - **FEAT**: add stow_secure.

---

#### `stow_plain` - `v0.1.1`

 - **DOC**: Added more documentation, comments, and instructions


## 2025-06-22

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`stow` - `v0.1.0`](#stow---v010)
 - [`stow_codecs` - `v1.0.0`](#stow_codecs---v100)
 - [`stow_plain` - `v0.1.0`](#stow_plain---v010)

---

#### `stow` - `v0.1.0`

 - **FEAT**: add PlainStow for shared preferences.
 - **FEAT**: add Stow, MemoryStow, and IdentityCodec.

---

#### `stow_codecs` - `v1.0.0`

 - **FEAT**: add EnumCodec.
 - **FEAT**: add ColorCodec.
 - **FEAT**: add PlainStow.json.
 - **FEAT**: add Stow, MemoryStow, and IdentityCodec.

---

#### `stow_plain` - `v0.1.0`

 - **FEAT**: add EnumCodec.
 - **FEAT**: add ColorCodec.
 - **FEAT**: add PlainStow.json.
 - **FEAT**: add PlainStow for shared preferences.
