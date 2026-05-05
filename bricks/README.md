# Bricks

The `bricks/` directory contains all Mason bricks used by `flutter_factory`.

Each brick should be small, focused, and architecture-aware. Bricks should generate production-ready code that matches the Clean Architecture and feature-first conventions documented in this repository.

Expected structure per brick:

- `brick.yaml`: Mason metadata, variables, and description.
- `__brick__/`: generated file templates.
- `hooks/`: optional pre-generation and post-generation Dart hooks.
- `README.md`: usage notes and example generated output for that brick.
- `test/`: optional generation tests for important output.

Current planned bricks:

- `feature/`: creates a full feature module with Riverpod or Bloc presentation scaffolding.
- `page/`: creates a page inside an existing feature.
- `api_service/`: creates Dio-based API service scaffolding.
- `usecase/`: creates a domain use case.
- `widget/`: creates reusable feature or shared widgets.
