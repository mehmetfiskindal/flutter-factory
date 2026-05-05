import '../../data/models/{{name.snakeCase()}}_model.dart';
import '../repositories/{{name.snakeCase()}}_repository.dart';

final class Get{{name.pascalCase()}}ListUseCase {
  const Get{{name.pascalCase()}}ListUseCase({
    required {{name.pascalCase()}}Repository repository,
  }) : _repository = repository;

  final {{name.pascalCase()}}Repository _repository;

  Future<List<{{name.pascalCase()}}Model>> call() {
    return _repository.get{{name.pascalCase()}}List();
  }
}
