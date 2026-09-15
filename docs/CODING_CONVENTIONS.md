# Coding Conventions

This project is a C++ compiler, not a C compiler. Do not add C-only language
support unless it is also valid C++.

## General

- Prefer small, focused changes that can be reviewed independently.
- Keep code portable across current MSVC and at least one current GCC or Clang.
- Use the latest available C++ standard facilities when they simplify the
  design.
- Prefer standard library facilities before adding dependencies.
- Use vcpkg for third-party dependencies when dependencies are needed.

## C++

- Prefer modules for new architecture where toolchain support allows it.
- Prefer `constexpr` and `consteval` for compile-time invariants.
- Keep ownership explicit with value types, references, and standard smart
  pointers.
- Avoid undefined behavior, implementation-specific assumptions, and global
  mutable state.
- Add focused tests with each behavior change once test infrastructure exists.

## Performance and quality

- Favor clear algorithms first, then measure before optimizing.
- Keep diagnostics actionable and deterministic.
- Treat warnings, sanitizers, static analysis, and benchmarks as first-class
  infrastructure as they are introduced.
