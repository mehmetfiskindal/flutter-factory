{{#is_riverpod}}import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/{{name.snakeCase()}}_provider.dart';
import '../widgets/{{name.snakeCase()}}_empty_state.dart';

final class {{name.pascalCase()}}View extends ConsumerWidget {
  const {{name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch({{name.camelCase()}}ControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name.titleCase()}}'),
      ),
      body: state.when(
        data: (entity) => Center(
          child: Text(entity.title),
        ),
        error: (error, stackTrace) => {{name.pascalCase()}}EmptyState(
          message: error.toString(),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
{{/is_riverpod}}{{#is_bloc}}import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/{{name.snakeCase()}}_bloc.dart';
import '../widgets/{{name.snakeCase()}}_empty_state.dart';

final class {{name.pascalCase()}}View extends StatelessWidget {
  const {{name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name.titleCase()}}'),
      ),
      body: BlocBuilder<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
        builder: (context, state) {
          return switch (state) {
            {{name.pascalCase()}}Loaded(:final entity) => Center(
                child: Text(entity.title),
              ),
            {{name.pascalCase()}}Failure(:final message) => {{name.pascalCase()}}EmptyState(
                message: message,
              ),
            {{name.pascalCase()}}Loading() => const Center(
                child: CircularProgressIndicator(),
              ),
            _ => const {{name.pascalCase()}}EmptyState(),
          };
        },
      ),
    );
  }
}
{{/is_bloc}}
