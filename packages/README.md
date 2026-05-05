# Packages

The `packages/` directory is reserved for shared Dart or Flutter packages used across generated apps, the CLI, or internal tooling.

Typical packages may include:

- `core`: shared result types, errors, constants, and base abstractions.
- `utils`: reusable utility functions and extensions.
- `testing`: test helpers, mocks, fixtures, and generator assertions.
- `lint_rules`: shared analysis options or custom lint configuration.

Expected package structure:

- `pubspec.yaml`: package metadata and dependencies.
- `lib/`: public package API.
- `test/`: package tests.
- `README.md`: package purpose and usage examples.
