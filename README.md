# jai-sdl3

Jai bindings for [SDL3 v3.2.14](https://github.com/libsdl-org/SDL/releases/tag/release-3.2.14) using the Bindings Generator.

These bindings are 'pure', we don't add or change the interface to SDL3.

## Installation

Copy this into your modules folder, then:

- **Windows**: Put the proper (x64/arm64) DLL next to your executable and make sure its called `SDL3.dll`. Prebuilt DLLs [here](https://github.com/overlord-systems/jai-sdl3/releases/tag/v1.2_3.2.14).
- **Linux**: Ensure SDL3 binaries are installed on your system (thanks to @marvhus).
- **MacOS**: Place the `x86/arm64` dynamic library (download from [here](https://github.com/overlord-systems/jai-sdl3/releases/tag/v1.2_3.2.14)) next to your executable and make sure its called `libSDL3.0.dylib` (thanks to @4iwen).

SDL supports a ton of platforms, so adding support for things like Android/iOS/etc should be possible.

### MacOS Note

On (some?) MacOS machines the generater **requires** a `.a` static library (it can't generate bindings from a dylib, we get weird errors), but compiling a jai program fails if we try to link to that same `.a` library.

As such, we run the generator on the bundled `.a`, but the bindings link to the bundled `libSDL3.0_dynamic.dylib` and you are required to have `libSDL3.0.dylib` next to your executable.

The reason we do this is to ensure jai uses the dynamic library when compiling. If we simply places `.a` and `.dylib` with the same name in one folder, jai will always pick the `.a` static library and compilation will fail.

What the source of this mess is, and whether it will improve, is to be seen.

## Notes

Due to current limitations in the bindings generator, especially around nested macros, some enums (e.g. `SDL_WINDOW_...`) and macros (e.g. `SDL_WINDOWPOS_UNDEFINED`) don't get generated by default.

To fix this we hardcode some code in `generate.jai` that gets put at the top of the generated bindings file. As the bindings generator matures we should be able to get incrementally get rid of these until the bindings are fully automated.

## Contribution

Want to support a new platform or found some missing enums/macros not generated? please feel free to send a PR!

To support a new platform check `generate.jai` and replicate what's done in the Windows/Linux section for your platform, then run `jai generate.jai`.
