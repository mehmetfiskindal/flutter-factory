import '../../data/models/{{name.snakeCase()}}_model.dart';
import '../repositories/{{name.snakeCase()}}_repository.dart';

final class Get{{name.pascalCase()}}ByIdUseCase {
  const Get{{name.pascalCase()}}ByIdUseCase({
    required {{name.pascalCase()}}Repository repository,
  }) : _repository = repository;

  final {{name.pascalCase()}}Repository _repository;

  Future<{{name.pascalCase()}}Model> call(String id) {
    return _repository.get{{name.pascalCase()}}ById(id);
  }
}
