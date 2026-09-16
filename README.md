# caipr

C++ AI Powered Refinery - A refined approach to compiling C++.

caipr is a C++ compiler built from scratch. It is not a C compiler and will not
support C features that are not part of C++.

## Project direction

- Build in small, reviewable increments.
- Start with infrastructure for code quality and performance.
- Prefer latest available C++ standard implementations, including modules and
  compile-time facilities such as `consteval`.
- Use a package manager, preferably vcpkg, for external dependencies.
- Stay cross-platform from the start, targeting current MSVC and at least one of
  current GCC or Clang.
- Treat AI as a primary contributor tool, with human-authored requirements and
  human review.

## Contributing

See [docs/CODING_CONVENTIONS.md](docs/CODING_CONVENTIONS.md) for coding
guidelines and [AGENTS.md](AGENTS.md) for AI contributor instructions.

## Build and test

```sh
cmake -S . -B build
cmake --build build --config Debug
ctest --test-dir build -C Debug
```

## License

No license is granted. See [LICENSE.md](LICENSE.md).
