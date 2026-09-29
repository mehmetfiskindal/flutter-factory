import 'package:flutter/material.dart';
{{#is_riverpod}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{/is_riverpod}}{{#is_bloc}}
import 'package:flutter_bloc/flutter_bloc.dart';
{{/is_bloc}}

import '../{{state_folder}}/{{name.snakeCase()}}_{{state_suffix}}.dart';

{{#is_riverpod}}
class {{name.pascalCase()}}View extends ConsumerWidget {
  const {{name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch({{name.camelCase()}}ControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name.titleCase()}}'),
      ),
      body: state.when(
        data: (title) => Center(
          child: Text(title),
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
{{/is_riverpod}}{{#is_bloc}}
class {{name.pascalCase()}}View extends StatelessWidget {
  const {{name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => {{name.pascalCase()}}Cubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('{{name.titleCase()}}'),
        ),
        body: BlocBuilder<{{name.pascalCase()}}Cubit, String>(
          builder: (context, state) => Center(
            child: Text(state),
          ),
        ),
      ),
    );
  }
}
{{/is_bloc}}
{{#is_native}}
class {{name.pascalCase()}}View extends StatefulWidget {
  const {{name.pascalCase()}}View({
    required this.viewModel,
    super.key,
  });

  final {{name.pascalCase()}}ViewModel viewModel;

  @override
  State<{{name.pascalCase()}}View> createState() =>
      _{{name.pascalCase()}}ViewState();
}

class _{{name.pascalCase()}}ViewState extends State<{{name.pascalCase()}}View> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        final viewModel = widget.viewModel;

        return Scaffold(
          appBar: AppBar(
            title: const Text('{{name.titleCase()}}'),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(viewModel.title),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: viewModel.isLoading ? null : viewModel.refresh,
                  child: viewModel.isLoading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Refresh'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
{{/is_native}}
