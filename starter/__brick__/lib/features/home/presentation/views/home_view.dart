import 'package:flutter/material.dart';
{{#is_riverpod}}{{#include_auth}}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/auth/presentation/providers/auth_controller.dart';
{{/include_auth}}{{/is_riverpod}}{{#is_bloc}}{{#include_auth}}import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/auth/presentation/controllers/auth_bloc.dart';
{{/include_auth}}{{/is_bloc}}
{{#is_native}}{{#include_auth}}import '../../../../features/auth/presentation/viewmodels/auth_view_model.dart';
{{/include_auth}}{{/is_native}}

{{#is_riverpod}}{{#include_auth}}
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Hello, ${user?.displayName ?? user?.email ?? 'there'}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'This screen is inside a GoRouter ShellRoute and shares app shell navigation.',
          ),
        ],
      ),
    );
  }
}
{{/include_auth}}{{^include_auth}}
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeContent();
  }
}
{{/include_auth}}{{/is_riverpod}}{{#is_bloc}}{{#include_auth}}
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Hello, ${user?.displayName ?? user?.email ?? 'there'}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'This screen is inside a GoRouter ShellRoute and shares app shell navigation.',
          ),
        ],
      ),
    );
  }
}
{{/include_auth}}{{^include_auth}}
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeContent();
  }
}
{{/include_auth}}
{{/is_bloc}}
{{#is_native}}{{#include_auth}}
class HomeView extends StatelessWidget {
  const HomeView({
    required this.viewModel,
    super.key,
  });

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final user = viewModel.user;

        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Hello, ${user?.displayName ?? user?.email ?? 'there'}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              const Text(
                'This screen is inside a GoRouter ShellRoute and shares app shell navigation.',
              ),
            ],
          ),
        );
      },
    );
  }
}
{{/include_auth}}{{^include_auth}}class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => const _HomeContent();
}
{{/include_auth}}{{/is_native}}
{{^include_auth}}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Hello there',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'This screen is inside a GoRouter ShellRoute and shares app shell navigation.',
          ),
        ],
      ),
    );
  }
}
{{/include_auth}}
