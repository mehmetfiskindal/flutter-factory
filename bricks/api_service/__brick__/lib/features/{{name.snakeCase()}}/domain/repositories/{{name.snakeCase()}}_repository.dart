import '../../data/models/{{name.snakeCase()}}_model.dart';

abstract interface class {{name.pascalCase()}}Repository {
  Future<List<{{name.pascalCase()}}Model>> get{{name.pascalCase()}}List();

  Future<{{name.pascalCase()}}Model> get{{name.pascalCase()}}ById(String id);

  Future<{{name.pascalCase()}}Model> create{{name.pascalCase()}}({
    required Map<String, dynamic> payload,
  });
}
