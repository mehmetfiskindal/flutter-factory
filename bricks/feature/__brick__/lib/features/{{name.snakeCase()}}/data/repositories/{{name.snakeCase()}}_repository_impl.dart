import '../../domain/entities/{{name.snakeCase()}}.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';
import '../datasources/{{name.snakeCase()}}_remote_datasource.dart';

final class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  const {{name.pascalCase()}}RepositoryImpl({
    required {{name.pascalCase()}}RemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final {{name.pascalCase()}}RemoteDataSource _remoteDataSource;

  @override
  Future<{{name.pascalCase()}}Entity> get{{name.pascalCase()}}() {
    return _remoteDataSource.get{{name.pascalCase()}}();
  }
}
