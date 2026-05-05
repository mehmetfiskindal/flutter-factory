import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';
import '../models/{{name.snakeCase()}}_model.dart';
import '../services/{{name.snakeCase()}}_api_service.dart';

final class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  const {{name.pascalCase()}}RepositoryImpl({
    required {{name.pascalCase()}}ApiService apiService,
  }) : _apiService = apiService;

  final {{name.pascalCase()}}ApiService _apiService;

  @override
  Future<List<{{name.pascalCase()}}Model>> get{{name.pascalCase()}}List() {
    return _apiService.get{{name.pascalCase()}}List();
  }

  @override
  Future<{{name.pascalCase()}}Model> get{{name.pascalCase()}}ById(String id) {
    return _apiService.get{{name.pascalCase()}}ById(id);
  }

  @override
  Future<{{name.pascalCase()}}Model> create{{name.pascalCase()}}({
    required Map<String, dynamic> payload,
  }) {
    return _apiService.create{{name.pascalCase()}}(payload: payload);
  }
}
