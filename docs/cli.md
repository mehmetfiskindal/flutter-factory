# CLI Reference

## Local Verification

Use `flutter_factory verify` to check starter generation on your machine without
GitHub Actions or hosted CI.

```bash
flutter_factory verify
flutter_factory verify --full
flutter_factory verify --no-analyze
```

- Default mode generates four representative starter combinations.
- `--full` generates all state/backend/auth/offline combinations.
- `--no-analyze` skips `flutter pub get` and `flutter analyze`.

## Page Routes

`add page` generates a view, state binding, and route file, then wires the route
into starter router files when flutter-factory markers are present.

```bash
flutter_factory add page dashboard --feature profile
flutter_factory add page activity_log --feature profile --path /profile/activity
flutter_factory add page draft --feature profile --no-route
```

- `--path` changes the generated route path.
- `--no-route` keeps the files generated but skips router edits.
- `--state riverpod|bloc|native` selects the page's state binding. If omitted, the
  command uses `state_management` from the current project's
  `.flutter_factory.yaml` and falls back to Riverpod.
- An override changes generated code but does not edit `pubspec.yaml`. Native
  output uses Flutter SDK `ChangeNotifier` and `ListenableBuilder`; it needs no
  additional state-management dependency. Riverpod or Bloc packages must
  already be installed for those overrides.

## API Services

`add api` generates a Dio service, Freezed model, repository contract and
implementation, use cases, and state-specific wiring.

```bash
flutter_factory add api billing --endpoint /v1/billing
flutter_factory add api billing --endpoint /v1/billing --state bloc
flutter_factory add api billing --endpoint /v1/billing --no-codegen
```

The state defaults to the current project's `.flutter_factory.yaml` value and
then to Riverpod. Riverpod projects get providers; Bloc and native projects get
a dependency bundle that can be composed with a Bloc/Cubit or Flutter SDK
ViewModel. The API brick requires the REST + Firebase hybrid preset because
Firebase-only starter projects do not include Dio.

## Project Defaults

`flutter_factory create` writes `.flutter_factory.yaml` into the generated
project. It records state management, backend, organization, auth, and offline
settings so later `add feature`, `add page`, and `add api` commands follow the
project preset. Per-command `--state` options override the recorded state.

`flutter_factory config` writes the same file in the current directory. Run it
from a project directory to set defaults for that project.

## Other Commands

- `flutter_factory create <app_name>` creates the Flutter shell and renders the
  starter brick. Options include `--org`, `--state`, `--backend`, `--auth`,
  `--offline`, and comma-separated `--platforms`.
- `flutter_factory add feature <name>` creates a feature with the selected
  state binding. Use `--state` to override project defaults.
- `flutter_factory add usecase <name> --feature <feature>` adds a domain use
  case.
- `flutter_factory add widget <name> --feature <feature>` adds a reusable
  presentation widget.
- `flutter_factory doctor [--firebase]` checks local tooling and brick
  availability. `--firebase` also checks Firebase CLI and FlutterFire CLI.
- `flutter_factory verify [--full] [--no-analyze]` renders representative or
  all 24 starter combinations. The default run also invokes `flutter pub get`
  and `flutter analyze`; `--no-analyze` only checks generation.
