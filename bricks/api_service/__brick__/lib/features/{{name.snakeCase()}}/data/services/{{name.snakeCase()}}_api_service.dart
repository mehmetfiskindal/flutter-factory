import 'package:dio/dio.dart';

import '../models/{{name.snakeCase()}}_model.dart';

final class {{name.pascalCase()}}ApiService {
  const {{name.pascalCase()}}ApiService({
    required Dio client,
    this.endpoint = '{{{endpoint}}}',
  }) : _client = client;

  final Dio _client;
  final String endpoint;

  Future<List<{{name.pascalCase()}}Model>> get{{name.pascalCase()}}List() async {
    final response = await _client.get<List<dynamic>>(endpoint);
    final data = response.data ?? const [];

    return data
        .map((item) => {{name.pascalCase()}}Model.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<{{name.pascalCase()}}Model> get{{name.pascalCase()}}ById(String id) async {
    final response = await _client.get<Map<String, dynamic>>('$endpoint/$id');
    final data = response.data;

    if (data == null) {
      throw StateError('Empty {{name.pascalCase()}} response for id $id.');
    }

    return {{name.pascalCase()}}Model.fromJson(data);
  }

  Future<{{name.pascalCase()}}Model> create{{name.pascalCase()}}({
    required Map<String, dynamic> payload,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      endpoint,
      data: payload,
    );
    final data = response.data;

    if (data == null) {
      throw StateError('Empty {{name.pascalCase()}} response after create.');
    }

    return {{name.pascalCase()}}Model.fromJson(data);
  }
}
