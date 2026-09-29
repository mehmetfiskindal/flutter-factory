# Generated App Architecture

Generated apps use Clean Architecture inside feature-first folders. The starter
keeps app-wide setup under `lib/app/` and `lib/core/`; each feature owns its
presentation and, when needed, data and domain code.

## Main areas

- `lib/app/` boots the app, configures dependencies, reads environment values,
  and builds the GoRouter configuration.
- `lib/core/` contains shared errors, logging, routing, theme, extensions, and
  helpers. REST projects also receive Dio and optional cache infrastructure.
- `lib/features/` contains `home` and `settings` starter screens. The optional
  `auth` feature contains authentication data, domain, and presentation code.
- `test/` contains the starter widget test. It is a smoke placeholder intended
  to be replaced with app-specific tests.

An added feature follows this shape:

```text
lib/features/profile/
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
    widgets/
    providers/       # Riverpod
    controllers/     # Bloc
    viewmodels/      # Flutter SDK ChangeNotifier
```

## Layer responsibilities

- **Presentation** owns views, reusable widgets, and state bindings. Riverpod
  output uses providers; Bloc output uses controllers or Cubits; native output
  uses Flutter SDK ViewModels with `ChangeNotifier` and `ListenableBuilder`.
- **Domain** contains business entities, repository contracts, and use cases.
- **Data** implements repository contracts and communicates with remote or
  local data sources.
- **App** composes global dependencies and routes. Keep feature-specific
  business rules out of this layer.
- **Core** contains infrastructure shared by multiple features. Avoid placing
  feature-specific models or operations here.

The generated `home` and `settings` screens are starter examples, not complete
product features. Add real repositories, use cases, and tests as app behavior is
defined.

See [starter template](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/docs/starter-template.md)
for conditional output and [bricks](file:///Users/mehmetfiskindal/Developer/flutter-starter-project/docs/bricks.md)
for generated feature modules.
