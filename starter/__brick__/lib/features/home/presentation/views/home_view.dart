import 'package:flutter/material.dart';
{{#is_riverpod}}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/auth/presentation/providers/auth_controller.dart';
{{/is_riverpod}}{{#is_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/auth/presentation/controllers/auth_bloc.dart';
{{/is_bloc}}

{{#is_riverpod}}
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
{{/is_riverpod}}{{#is_bloc}}
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
{{/is_bloc}}
