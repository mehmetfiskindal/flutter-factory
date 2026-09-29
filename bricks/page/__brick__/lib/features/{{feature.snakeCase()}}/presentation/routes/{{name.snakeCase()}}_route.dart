import 'package:go_router/go_router.dart';

import '../views/{{name.snakeCase()}}_view.dart';
{{#is_native}}import '../viewmodels/{{name.snakeCase()}}_view_model.dart';
{{/is_native}}

abstract final class {{name.pascalCase()}}Route {
  static const path = '{{route_path}}';
  static const name = '{{name.camelCase()}}';

  static GoRoute route() {
    return GoRoute(
      path: path,
      name: name,
      builder: (context, state) => {{#is_native}}{{name.pascalCase()}}View(
        viewModel: {{name.pascalCase()}}ViewModel(),
      ){{/is_native}}{{^is_native}}const {{name.pascalCase()}}View(){{/is_native}},
    );
  }
}
