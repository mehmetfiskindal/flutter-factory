export 'data/models/{{name.snakeCase()}}_model.dart';
export 'data/repositories/{{name.snakeCase()}}_repository_impl.dart';
export 'data/services/{{name.snakeCase()}}_api_service.dart';
export 'domain/repositories/{{name.snakeCase()}}_repository.dart';
export 'domain/usecases/create_{{name.snakeCase()}}.dart';
export 'domain/usecases/get_{{name.snakeCase()}}_by_id.dart';
export 'domain/usecases/get_{{name.snakeCase()}}_list.dart';
{{#is_riverpod}}export 'providers.dart';{{/is_riverpod}}{{#is_bloc}}export 'dependencies.dart';{{/is_bloc}}{{#is_native}}export 'dependencies.dart';{{/is_native}}
