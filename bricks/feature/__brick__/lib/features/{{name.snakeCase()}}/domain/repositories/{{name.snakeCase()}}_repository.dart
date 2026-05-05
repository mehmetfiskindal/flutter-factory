import '../entities/{{name.snakeCase()}}.dart';

abstract interface class {{name.pascalCase()}}Repository {
  Future<{{name.pascalCase()}}Entity> get{{name.pascalCase()}}();
}
