import '../entities/{{name.snakeCase()}}.dart';
import '../repositories/{{name.snakeCase()}}_repository.dart';

final class Get{{name.pascalCase()}}UseCase {
  const Get{{name.pascalCase()}}UseCase({
    required {{name.pascalCase()}}Repository repository,
  }) : _repository = repository;

  final {{name.pascalCase()}}Repository _repository;

  Future<{{name.pascalCase()}}Entity> call() {
    return _repository.get{{name.pascalCase()}}();
  }
}
