{{#is_riverpod}}
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/models/{{name.snakeCase()}}_model.dart';
import 'data/repositories/{{name.snakeCase()}}_repository_impl.dart';
import 'data/services/{{name.snakeCase()}}_api_service.dart';
import 'domain/repositories/{{name.snakeCase()}}_repository.dart';
import 'domain/usecases/create_{{name.snakeCase()}}.dart';
import 'domain/usecases/get_{{name.snakeCase()}}_by_id.dart';
import 'domain/usecases/get_{{name.snakeCase()}}_list.dart';

final {{name.camelCase()}}DioProvider = Provider<Dio>((ref) {
  throw UnimplementedError(
    'Override {{name.camelCase()}}DioProvider with your configured Dio client.',
  );
});

final {{name.camelCase()}}ApiServiceProvider = Provider<{{name.pascalCase()}}ApiService>((ref) {
  return {{name.pascalCase()}}ApiService(
    client: ref.watch({{name.camelCase()}}DioProvider),
  );
});

final {{name.camelCase()}}RepositoryProvider =
    Provider<{{name.pascalCase()}}Repository>((ref) {
  return {{name.pascalCase()}}RepositoryImpl(
    apiService: ref.watch({{name.camelCase()}}ApiServiceProvider),
  );
});

final get{{name.pascalCase()}}ListUseCaseProvider =
    Provider<Get{{name.pascalCase()}}ListUseCase>((ref) {
  return Get{{name.pascalCase()}}ListUseCase(
    repository: ref.watch({{name.camelCase()}}RepositoryProvider),
  );
});

final get{{name.pascalCase()}}ByIdUseCaseProvider =
    Provider<Get{{name.pascalCase()}}ByIdUseCase>((ref) {
  return Get{{name.pascalCase()}}ByIdUseCase(
    repository: ref.watch({{name.camelCase()}}RepositoryProvider),
  );
});

final create{{name.pascalCase()}}UseCaseProvider =
    Provider<Create{{name.pascalCase()}}UseCase>((ref) {
  return Create{{name.pascalCase()}}UseCase(
    repository: ref.watch({{name.camelCase()}}RepositoryProvider),
  );
});

final {{name.camelCase()}}ListProvider =
    FutureProvider.autoDispose<List<{{name.pascalCase()}}Model>>((ref) {
  return ref.watch(get{{name.pascalCase()}}ListUseCaseProvider).call();
});

final {{name.camelCase()}}ByIdProvider =
    FutureProvider.autoDispose.family<{{name.pascalCase()}}Model, String>((ref, id) {
  return ref.watch(get{{name.pascalCase()}}ByIdUseCaseProvider).call(id);
});
{{/is_riverpod}}{{#uses_direct_dependencies}}
import 'package:dio/dio.dart';

import 'data/repositories/{{name.snakeCase()}}_repository_impl.dart';
import 'data/services/{{name.snakeCase()}}_api_service.dart';
import 'domain/repositories/{{name.snakeCase()}}_repository.dart';
import 'domain/usecases/create_{{name.snakeCase()}}.dart';
import 'domain/usecases/get_{{name.snakeCase()}}_by_id.dart';
import 'domain/usecases/get_{{name.snakeCase()}}_list.dart';

final class {{name.pascalCase()}}Dependencies {
  factory {{name.pascalCase()}}Dependencies({required Dio client}) {
    final apiService = {{name.pascalCase()}}ApiService(client: client);
    final repository = {{name.pascalCase()}}RepositoryImpl(
      apiService: apiService,
    );

    return {{name.pascalCase()}}Dependencies._(
      apiService: apiService,
      repository: repository,
      createUseCase: Create{{name.pascalCase()}}UseCase(repository: repository),
      getByIdUseCase: Get{{name.pascalCase()}}ByIdUseCase(
        repository: repository,
      ),
      getListUseCase: Get{{name.pascalCase()}}ListUseCase(
        repository: repository,
      ),
    );
  }

  const {{name.pascalCase()}}Dependencies._({
    required this.apiService,
    required this.repository,
    required this.createUseCase,
    required this.getByIdUseCase,
    required this.getListUseCase,
  });

  final {{name.pascalCase()}}ApiService apiService;
  final {{name.pascalCase()}}Repository repository;
  final Create{{name.pascalCase()}}UseCase createUseCase;
  final Get{{name.pascalCase()}}ByIdUseCase getByIdUseCase;
  final Get{{name.pascalCase()}}ListUseCase getListUseCase;
}
{{/uses_direct_dependencies}}
