# CLI

The `cli/` package contains the Dart command-line tool exposed as `flutter_factory`.

Its role is to provide a developer-friendly interface over Mason bricks, validate user input, run environment checks, and generate apps or feature modules with consistent defaults.

Current commands:

- `flutter_factory create <app_name>`: creates a new Flutter project from the starter brick.
- `flutter_factory add feature <name>`: adds a feature-first Clean Architecture module.
- `flutter_factory add api <name> --endpoint <endpoint>`: adds Dio service, Freezed model, repository, use cases, and Riverpod providers.
- `flutter_factory add page <name> --feature <feature_name>`: adds a page inside a feature.
- `flutter_factory config`: runs interactive setup for state management, backend, auth, and offline defaults.

Expected core files:

- `pubspec.yaml`: Dart package metadata, CLI executable mapping, and CLI dependencies.
- `bin/flutter_factory.dart`: executable entry point used by `dart pub global activate`.
- `lib/src/command_runner.dart`: top-level command runner configuration.
- `lib/src/commands/`: command implementations such as `create`, `doctor`, `make`, and `bricks`.
- `lib/src/config/`: CLI configuration, defaults, and project discovery helpers.
- `lib/src/generator/`: Mason integration layer that invokes local or remote bricks.
- `test/`: command and generator behavior tests.
