# flutter-factory

> Generate production-ready Flutter apps in seconds.

**flutter-factory** is a Mason-powered Flutter project generator with an ergonomic CLI for creating consistent, scalable, production-ready Flutter applications.

It is designed for mid-to-senior Flutter developers, freelancers, and small-to-medium teams that want to move fast without rebuilding the same architecture, folders, services, pages, and feature modules from scratch every time.

Guides: [CLI reference](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/docs/cli.md) · [Architecture](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/docs/architecture.md) · [Bricks](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/docs/bricks.md) · [Starter template](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/docs/starter-template.md)

## What Is flutter-factory?

flutter-factory combines the flexibility of [Mason](https://pub.dev/packages/mason_cli) bricks with a purpose-built CLI named `flutter_factory`.

Mason handles the generation engine. `flutter_factory` gives developers a clean command interface for creating full apps, features, pages, API services, use cases, and other architecture-aware building blocks.

The goal is simple: generate a real Flutter app foundation that is ready for production patterns from the first commit.

## Features

| Feature | Description |
| --- | --- |
| App Generator | Create a complete Flutter application with selected architecture, state management, routing, networking, and folder conventions. |
| Feature Brick | Generate a feature-first module with presentation, domain, and data layers. |
| API Service Brick | Create typed API service scaffolding designed for Dio-based networking. |
| Page Brick | Generate new screens with routing-ready structure and state-management integration. |
| UseCase Brick | Add domain use cases that keep business logic isolated and testable. |
| CLI Wrapper | Use `flutter_factory` instead of memorizing raw Mason commands and brick variables. |
| Consistent Output | Keep teams aligned with repeatable project structure, naming, and architecture decisions. |
| Production Defaults | Start with battle-tested packages and predictable conventions instead of a blank app shell. |

## Architecture

flutter-factory is built around **Clean Architecture** and a **feature-first** project structure.

Instead of grouping the app only by technical layer, each feature owns its presentation, domain, and data concerns. Furthermore, optional folders (`auth`, `cache`, `offline`, `firebase`) are generated conditionally based on configuration flags to keep the codebase clean.

```text
lib/
  app/
    app.dart                  # Application widget wrapper
    di.dart                   # Dependency injection configuration
    flavor.dart               # Environment configuration loader
    router.dart               # Main GoRouter configuration
  core/
    di/                       # Core di / providers definition
    error/                    # Custom failure and exception types
    logging/                  # Logging utility and setup
    network/                  # HTTP client, interceptors, and token storage (REST only)
    router/                   # Route path constants
    theme/                    # App styles and light/dark theme specifications
    utils/                    # Common helper utilities and constants
    cache/                    # Local storage caching service (REST and auth/offline only) [CONDITIONAL]
    offline/                  # Network connectivity service (offline support only) [CONDITIONAL]
    firebase/                 # Firebase services (Firebase backend only) [CONDITIONAL]
  features/
    home/                     # Basic feature template (always generated)
      presentation/
        views/
    settings/                 # Basic feature template (always generated)
      presentation/
        views/
    auth/                     # Scaffolding for user authentication (optional) [CONDITIONAL]
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        views/
        providers/            # Riverpod
        controllers/          # Bloc
        viewmodels/           # Flutter SDK ChangeNotifier
        widgets/
```

This structure helps teams keep feature code close together while still preserving clear separation of concerns:

- **Presentation** handles UI, views (screens), widgets, and state bindings (providers or controllers).
- **Domain** contains entities, repository contracts, and use cases.
- **Data** implements API/Firestore data sources, models, and repository implementations.
- **App** contains global application-wide initializations, routing entry points, and dependency injection setup.
- **Core** stores shared infrastructure such as common providers, custom error types, logging configuration, networking, themes, and helper utilities.

## Usage

### Local usage without BrickHub

You do **not** need to publish bricks to [brickhub.dev](https://brickhub.dev) during development.

flutter-factory supports local usage in two ways:

1. Use the `flutter_factory` CLI from this repository.
2. Use Mason directly with local brick paths.

#### Option 1: Use the local CLI

Clone this repository and activate the CLI from the local `cli/` package:

```bash
git clone <your-repo-url> flutter-factory
cd flutter-factory
dart pub global activate -s path ./cli
```

Point the CLI to the local flutter-factory repository so it can find `starter/` and `bricks/`:

```bash
export FLUTTER_FACTORY_ROOT="$(pwd)"
```

Now you can generate from local bricks without BrickHub:

```bash
flutter_factory doctor
flutter_factory create my_app --org com.fiskindal --state riverpod --auth --offline
flutter_factory create my_app --org com.fiskindal --state native --auth
cd my_app
flutter_factory add feature profile --state riverpod
flutter_factory add api billing --endpoint /v1/billing
flutter_factory add page dashboard --feature profile
flutter_factory add page activity_log --feature profile --path /profile/activity
flutter_factory verify --no-analyze
```

If you do not want to activate the CLI globally, run it directly:

```bash
dart run cli/bin/flutter_factory.dart create my_app --org com.fiskindal --state riverpod --auth --offline
```

#### Option 2: Use Mason directly with local bricks

Install Mason CLI:

```bash
dart pub global activate mason_cli
```

Use the root `mason.yaml`, which already registers local brick paths:

```bash
mason get
```

Then run local bricks:

```bash
mason make feature --name auth --state_management riverpod
mason make api_service --name auth --endpoint /v1/auth
```

Run the starter brick locally into an output folder:

```bash
mason make starter \
  --output-dir ./my_app \
  --app_name my_app \
  --org_name com.fiskindal \
  --state_management riverpod \
  --backend rest_firebase_hybrid \
  --auth true \
  --offline_support true
```

Alternatively, add one brick manually from a local path:

```bash
mason add feature --path bricks/feature
mason make feature --name auth --state_management riverpod
```

### Published usage

Once the CLI package is published, install it globally:

```bash
dart pub global activate flutter_factory
```

Check your environment:

```bash
flutter_factory doctor
flutter_factory doctor --firebase
```

Create a new Flutter application:

```bash
flutter_factory create my_app --org com.fiskindal --state riverpod --auth --offline
flutter_factory create my_app --org com.fiskindal --state riverpod --backend firebase
flutter_factory create my_app --org com.fiskindal --state bloc --backend firebase
flutter_factory create my_app --org com.fiskindal --state native --backend firebase
```

Generate a new feature:

```bash
flutter_factory add feature profile
```

Generate a page inside a feature:

```bash
flutter_factory add page dashboard --feature profile
flutter_factory add page activity_log --feature profile --path /profile/activity
flutter_factory add page draft --feature profile --no-route
```

Generated pages are wired into the starter router automatically when route
markers are present.

Generate an API service:

```bash
flutter_factory add api billing --endpoint /v1/billing
```

Generate without running Freezed/build_runner immediately:

```bash
flutter_factory add api billing --endpoint /v1/billing --no-codegen
```

Generated projects keep their selected state management and backend in
`.flutter_factory.yaml`, so `add feature`, `add page`, and `add api` use the
project's preset by default. Override page or API wiring with `--state bloc`,
`--state riverpod`, or `--state native`. Native output uses Flutter SDK
`ChangeNotifier` and `ListenableBuilder` and adds no state-management package.
The API brick requires the REST + Firebase hybrid backend;
it is not available for Firebase-only projects.

Overwrite generated files intentionally:

```bash
flutter_factory add page dashboard --feature profile --force
```

Run interactive setup:

```bash
flutter_factory config
```

Verify starter generation locally without GitHub Actions:

```bash
flutter_factory verify
flutter_factory verify --full --no-analyze
```

## Supported Stack

flutter-factory is designed to support modern Flutter production stacks while keeping choices explicit.

| Area | Available |
| --- | --- |
| State management | Riverpod, Bloc, or Flutter SDK ViewModels (`ChangeNotifier`) |
| Networking | Dio for REST projects, with auth token refresh when REST auth is enabled |
| Backend | REST + Firebase hybrid, or Firebase with Firestore and Cloud Storage |
| Routing | GoRouter with auth redirects and shell routes |
| Models and serialization | Freezed and json_serializable |
| Code generation | build_runner |
| Project generation | Mason bricks |
| Tests | Starter widget test, plus CLI tests and generated-project analysis |
| Environment config | `--dart-define` flavor values |

## Why This Project?

Most Flutter projects begin with the same setup work:

- choosing a folder structure,
- wiring state management,
- configuring routing,
- creating network clients,
- defining error handling,
- adding feature modules,
- repeating boilerplate for pages, services, models, and use cases.

flutter-factory turns that repetitive setup into a fast, consistent, CLI-driven workflow.

| Approach | Strength | Trade-off |
| --- | --- | --- |
| Manual setup | Full control over every file | Slow, inconsistent, and easy to drift across projects or teams. |
| Raw Mason bricks | Powerful and flexible generation | Requires remembering brick names, variables, paths, and conventions. |
| Generic starter template | Fast initial clone | Hard to customize and often becomes stale after the first project. |
| flutter-factory | Fast generation with architecture-aware commands | Requires maintaining project-specific bricks and CLI conventions. |

flutter-factory is not just a starter template. It is a repeatable app factory for Flutter teams that want speed, consistency, and production-minded defaults.

## Available Now

- Local CLI activation with `dart pub global activate -s path ./cli`.
- `flutter_factory doctor` environment checks.
- `flutter_factory create <app_name> --org <reverse.domain>` with Flutter platform folders.
- Feature, API service, page, usecase, and widget generation.
- Default collision protection with opt-in `--force`.
- Optional `add api --no-codegen`.
- Generated app checks: `flutter_factory verify` runs `flutter pub get` and `flutter analyze`; run `flutter test` in a generated project for its starter test.

## Firebase Projects

Use the Firebase backend preset when the app should be generated without REST/Dio scaffolding:

```bash
flutter_factory create my_app --backend firebase --state riverpod
flutter_factory create my_app --backend firebase --state bloc
```

Firebase tooling checks are available with:

```bash
flutter_factory doctor --firebase
```

Firebase CLI is distributed as the npm package `firebase-tools`:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

`dart pub global activate flutterfire_cli` installs the FlutterFire CLI. Actual Firebase project and app configuration is still done from the generated project with:

```bash
firebase login
flutterfire configure
```

## Roadmap

- [x] MVP app generator with Clean Architecture and feature-first structure.
- [x] Core bricks for feature, page, API service, widget, and use case generation.
- [x] `flutter_factory doctor` environment checks.
- [x] Riverpod-first project template.
- [x] Bloc-compatible project template.
- [x] Flutter SDK state management without a third-party state package.
- [x] Dio networking module with interceptors and typed error handling.
- [x] GoRouter setup with generated route examples.
- [x] Freezed and json_serializable model generation.
- [ ] Meaningful unit, widget, and integration test presets (the current starter test is a smoke placeholder).
- [ ] CI/CD starter workflows.
- [ ] Multiple app templates for SaaS, marketplace, admin panel, and mobile-first products.
- [ ] Documentation website with guides and brick authoring recipes.

## Contributing

Contributions are welcome.

The best way to contribute is to help improve the generator experience for real Flutter projects:

- propose new bricks,
- improve generated architecture,
- add missing tests,
- refine CLI commands,
- document common workflows,
- report confusing defaults or edge cases.

Before opening a pull request:

1. Keep changes focused and easy to review.
2. Explain which generated output changes and why.
3. Include examples for new CLI commands or brick variables.
4. Add or update tests when generation behavior changes.
5. Update the README or docs when developer-facing behavior changes.

If you are proposing a new brick, include the intended generated folder structure and a short example command.

## License

This project is released under the [MIT License](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/LICENSE).
