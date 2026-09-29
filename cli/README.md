# CLI

The `cli/` package contains the Dart command-line tool exposed as `flutter_factory`.

Its role is to provide a developer-friendly interface over Mason bricks, validate user input, run environment checks, and generate apps or feature modules with consistent defaults.

Current commands:

- `flutter_factory create <app_name>`: creates a new Flutter project from the starter brick.
- `flutter_factory add feature <name>`: adds a feature-first Clean Architecture module.
- `flutter_factory add api <name> --endpoint <endpoint>`: adds Dio service, Freezed model, repository, use cases, and state-specific wiring.
- `flutter_factory add page <name> --feature <feature_name>`: adds a Riverpod, Bloc, or Flutter SDK ViewModel page inside a feature and wires it into the starter router when route markers are present.
- `flutter_factory add usecase <name> --feature <feature_name>`: adds a domain use case.
- `flutter_factory add widget <name> --feature <feature_name>`: adds a reusable widget.
- `flutter_factory config`: runs interactive setup for state management, backend, auth, and offline defaults.
- `flutter_factory doctor`: checks local tooling and brick availability.
- `flutter_factory verify`: locally generates starter samples and optionally runs `flutter analyze`.

## Local Development Usage

The CLI can be used without publishing anything to BrickHub.

From the repository root:

```bash
dart pub global activate -s path ./cli
export FLUTTER_FACTORY_ROOT="$(pwd)"
```

Then run:

```bash
flutter_factory create my_app --org com.fiskindal --state riverpod --auth --offline
flutter_factory create my_app --org com.fiskindal --state native --auth
cd my_app
flutter_factory add feature profile --state riverpod
flutter_factory add api billing --endpoint /v1/billing
flutter_factory add page dashboard --feature profile
flutter_factory add page activity_log --feature profile --path /profile/activity
flutter_factory add page draft --feature profile --no-route
flutter_factory add usecase sync_profile --feature profile
flutter_factory add widget profile_tile --feature profile
flutter_factory verify --no-analyze
```

For one-off usage without global activation:

```bash
dart run cli/bin/flutter_factory.dart create my_app --org com.fiskindal --state riverpod --auth --offline
```

`FLUTTER_FACTORY_ROOT` should point to the repository root that contains `mason.yaml`, `starter/`, `bricks/`, and `cli/`.

`create` writes the selected defaults to `.flutter_factory.yaml` in the generated
project. Later `add feature`, `add page`, and `add api` commands use that
project's state-management choice unless `--state` is provided. The API brick
requires the REST + Firebase hybrid backend; Firebase-only apps do not include
Dio.

Expected core files:

- `pubspec.yaml`: Dart package metadata, CLI executable mapping, and CLI dependencies.
- `bin/flutter_factory.dart`: executable entry point used by `dart pub global activate`.
- `lib/src/command_runner.dart`: top-level command runner configuration.
- `lib/src/commands/`: command implementations such as `create`, `add`, `config`, and `doctor`.
- `lib/src/config/`: CLI configuration, defaults, and project discovery helpers.
- `lib/src/generator/`: Mason integration layer that invokes local or remote bricks.
- `test/`: command and generator behavior tests.
