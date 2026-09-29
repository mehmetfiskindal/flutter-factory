# Mason Bricks

The local bricks live under `bricks/` and are registered in the root
`mason.yaml`. The CLI uses these templates directly, so they do not need to be
published to BrickHub.

| Brick | CLI command | State support | Output |
| --- | --- | --- | --- |
| `feature` | `add feature <name>` | Riverpod, Bloc, and Flutter SDK | Feature folders, a starter view, data/domain examples, and state binding |
| `page` | `add page <name> --feature <feature>` | Riverpod, Bloc, and Flutter SDK | View, state binding, GoRoute, and optional router integration |
| `api_service` | `add api <name>` | Riverpod, Bloc, and Flutter SDK | Dio service, Freezed model, repository, use cases, and providers or a dependency bundle |
| `usecase` | `add usecase <name> --feature <feature>` | State agnostic | Domain use case and placeholder test |
| `widget` | `add widget <name> --feature <feature>` | State agnostic | Reusable presentation widget |

## CLI examples

```bash
flutter_factory add feature profile
flutter_factory add feature settings --state native
flutter_factory add page dashboard --feature profile --path /profile/dashboard
flutter_factory add page dashboard --feature profile --state bloc
flutter_factory add page dashboard --feature profile --state native
flutter_factory add api billing --endpoint /v1/billing
flutter_factory add api billing --endpoint /v1/billing --state bloc
flutter_factory add api invoices --endpoint /v1/invoices --state native
flutter_factory add usecase refresh_profile --feature profile
flutter_factory add widget profile_tile --feature profile
```

The feature, page, and API commands read state management from the current
project's `.flutter_factory.yaml`, then fall back to Riverpod. Page and API
commands also accept `--state` to override that choice. The API brick uses Dio
and is intended for the REST + Firebase hybrid preset; Firebase-only starter
projects do not include Dio. A state override changes generated code but does
not edit `pubspec.yaml`; Riverpod and Bloc packages must already be installed.
Native output uses Flutter SDK ViewModels and adds no state package.

## Direct Mason usage

Run `mason get` from the repository root, then pass brick variables directly:

```bash
mason make feature --name profile --state_management bloc
mason make feature --name settings --state_management native
mason make page --name dashboard --feature profile --state_management bloc
mason make page --name preferences --feature settings --state_management native
mason make api_service --name billing --endpoint /v1/billing --state_management bloc
mason make api_service --name invoices --endpoint /v1/invoices --state_management native
```

## Brick maintenance

Each brick has a `brick.yaml` describing its variables, an optional `pre_gen`
hook for normalized values, and templates under `__brick__/`. The API brick's
post-generation hook runs `build_runner` when dependencies are present and
codegen is enabled; use `--no-codegen` to skip it. Generated `.freezed.dart`
and `.g.dart` files are build outputs, not brick templates.

After changing a brick, run the full starter verification required by the
repository's agent guide:

```bash
flutter_factory verify --full
```

This command checks starter combinations. For changes to page or API bricks,
also run the CLI test suite, which exercises their generated output.
