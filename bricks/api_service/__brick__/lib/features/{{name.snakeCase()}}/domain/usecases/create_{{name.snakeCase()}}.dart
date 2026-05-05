import '../../data/models/{{name.snakeCase()}}_model.dart';
import '../repositories/{{name.snakeCase()}}_repository.dart';

final class Create{{name.pascalCase()}}UseCase {
  const Create{{name.pascalCase()}}UseCase({
    required {{name.pascalCase()}}Repository repository,
  }) : _repository = repository;

  final {{name.pascalCase()}}Repository _repository;

  Future<{{name.pascalCase()}}Model> call({
    required Map<String, dynamic> payload,
  }) {
    return _repository.create{{name.pascalCase()}}(payload: payload);
  }
}
