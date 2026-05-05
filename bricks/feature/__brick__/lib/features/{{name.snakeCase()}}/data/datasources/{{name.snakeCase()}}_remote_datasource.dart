import '../models/{{name.snakeCase()}}_model.dart';

abstract interface class {{name.pascalCase()}}RemoteDataSource {
  Future<{{name.pascalCase()}}Model> get{{name.pascalCase()}}();
}

final class {{name.pascalCase()}}RemoteDataSourceImpl
    implements {{name.pascalCase()}}RemoteDataSource {
  @override
  Future<{{name.pascalCase()}}Model> get{{name.pascalCase()}}() async {
    return const {{name.pascalCase()}}Model(id: '1', title: '{{name.titleCase()}}');
  }
}
