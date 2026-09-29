# Contributing

Contributions should keep generated projects consistent across the CLI, Mason
bricks, starter template, and documentation.

## Setup

Install the Dart and Flutter SDKs and Mason CLI. From the repository root:

```bash
dart pub get --directory cli
dart pub global activate mason_cli
mason get
export FLUTTER_FACTORY_ROOT="$(pwd)"
```

Run the CLI without global activation with:

```bash
dart run cli/bin/flutter_factory.dart <command>
```

## Before submitting

For CLI changes, run:

```bash
cd cli
dart test
```

For starter or brick changes, activate or run the local CLI from the repository
root and verify generated output:

```bash
dart run cli/bin/flutter_factory.dart verify --full
```

The full verify command generates 24 starter combinations and, by default,
runs `flutter pub get` and `flutter analyze` for each. Use
`--full --no-analyze` when dependency resolution is unavailable and only
generation needs checking.

## Change expectations

- Keep changes focused and preserve unrelated working-tree edits.
- Update the CLI reference when a command or option changes.
- Update brick or starter documentation when generated output changes.
- Add or update CLI tests for command behavior and generated output.
- Avoid committing generated build output or temporary verify projects.
- Explain changed generated files and any setup required in the pull request.

See [monorepo structure](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/docs/monorepo-structure.md)
for file ownership and [architecture](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/docs/architecture.md)
for generated app conventions.
