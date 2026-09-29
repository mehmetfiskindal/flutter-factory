# Starter Template

`starter/` is a Mason brick rendered into a Flutter shell created by
`flutter_factory create`. The CLI first runs `flutter create` with the selected
organization and platforms, then writes the starter files and configuration.

## Presets

The starter accepts these variables:

| Variable | Choices | Default |
| --- | --- | --- |
| `state_management` | `riverpod`, `bloc`, `native` | `riverpod` |
| `backend` | `rest_firebase_hybrid`, `firebase` | `rest_firebase_hybrid` |
| `auth` | `true`, `false` | `false` |
| `offline_support` | `true`, `false` | `false` |

All state options use the same feature-first structure. `native` generates
Flutter SDK `ChangeNotifier` ViewModels observed with `ListenableBuilder`; it
does not add Riverpod or Bloc packages. Use `setState` for short-lived state
owned by a single widget. The selected backend controls which packages and
infrastructure are generated:

- `rest_firebase_hybrid` includes Dio and REST networking. Auth adds token
  storage and refresh handling. REST auth or offline support also enables the
  Hive cache stores.
- `firebase` includes Firebase Core, Firestore, and Cloud Storage. Firebase
  Auth is included only when `auth` is enabled. It does not include Dio, so the
  `add api` REST brick is unavailable for this preset.
- `offline_support` adds a connectivity service and banner. Firestore provides
  its own native offline persistence; the starter does not add a separate
  Firebase sync queue.

The generated `.flutter_factory.yaml` records these choices. The CLI uses it
when later adding features, pages, and API services.

## Firebase setup

`lib/firebase_options.dart` is a compiling placeholder for generated Firebase
projects. Before running the app, install Firebase CLI and FlutterFire CLI,
then run `firebase login` and `flutterfire configure` in the generated project.
FlutterFire replaces the placeholder with project-specific configuration.

## Environments

The starter includes `config/env/dev.json`, `staging.json`, and `prod.json` for
Flutter's `--dart-define-from-file` option. They set `FLAVOR`, `APP_NAME`,
`API_BASE_URL`, `ENABLE_NETWORK_LOGS`, and `SHOW_DEBUG_BANNER`.

```bash
flutter run --dart-define-from-file=config/env/dev.json
flutter build apk --dart-define-from-file=config/env/prod.json
```

The defaults in `lib/app/flavor.dart` are used when a define is omitted.

## Verification and tests

`flutter_factory verify` renders four representative combinations, runs
`flutter pub get`, and runs `flutter analyze` on each generated app. Add
`--full` to render all 24 state/backend/auth/offline combinations. Add
`--no-analyze` to check template rendering without dependency resolution or
analysis.

The starter's `test/widget_test.dart` is an intentionally minimal smoke test.
Replace it with widget and unit tests for the generated app's actual behavior.
