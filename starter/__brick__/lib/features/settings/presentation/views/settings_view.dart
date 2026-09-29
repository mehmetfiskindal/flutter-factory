import 'package:flutter/material.dart';
{{#is_riverpod}}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/flavor.dart';
{{#include_auth}}
import '../../../../features/auth/presentation/providers/auth_controller.dart';
{{/include_auth}}
{{/is_riverpod}}{{#is_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/flavor.dart';
{{#include_auth}}
import '../../../../features/auth/presentation/controllers/auth_bloc.dart';
{{/include_auth}}
{{/is_bloc}}
{{#is_native}}import '../../../../app/flavor.dart';
{{#include_auth}}import '../../../../features/auth/presentation/viewmodels/auth_view_model.dart';
{{/include_auth}}{{/is_native}}

{{#is_riverpod}}
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(appEnvironmentProvider);
    {{#include_auth}}
    final authState = ref.watch(authControllerProvider);
    {{/include_auth}}

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            title: const Text('Flavor'),
            subtitle: Text(environment.flavor.name),
          ),
          ListTile(
            title: const Text('API base URL'),
            subtitle: Text(environment.apiBaseUrl),
          ),
          {{#include_auth}}
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: authState.isLoading
                ? null
                : () => ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
          {{/include_auth}}
        ],
      ),
    );
  }
}
{{/is_riverpod}}{{#is_bloc}}
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final environment = context.read<AppEnvironment>();
    {{#include_auth}}
    final authState = context.watch<AuthBloc>().state;
    final isLoading = authState is AuthLoading;
    {{/include_auth}}

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            title: const Text('Flavor'),
            subtitle: Text(environment.flavor.name),
          ),
          ListTile(
            title: const Text('API base URL'),
            subtitle: Text(environment.apiBaseUrl),
          ),
          {{#include_auth}}
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: isLoading
                ? null
                : () => context.read<AuthBloc>().add(
                      const SignOutRequested(),
                    ),
            child: const Text('Sign out'),
          ),
          {{/include_auth}}
        ],
      ),
    );
  }
}
{{/is_bloc}}
{{#is_native}}
class SettingsView extends StatelessWidget {
  const SettingsView({
    required this.environment,
    {{#include_auth}}required this.viewModel,
    {{/include_auth}}super.key,
  });

  final AppEnvironment environment;
  {{#include_auth}}final AuthViewModel viewModel;
  {{/include_auth}}

  @override
  Widget build(BuildContext context) {
    {{#include_auth}}return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) => _buildSettings(context),
    );
    {{/include_auth}}{{^include_auth}}return _buildSettings(context);
    {{/include_auth}}
  }

  Widget _buildSettings(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            title: const Text('Flavor'),
            subtitle: Text(environment.flavor.name),
          ),
          ListTile(
            title: const Text('API base URL'),
            subtitle: Text(environment.apiBaseUrl),
          ),
          {{#include_auth}}const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: viewModel.isLoading ? null : viewModel.signOut,
            child: const Text('Sign out'),
          ),
          {{/include_auth}}
        ],
      ),
    );
  }
}
{{/is_native}}
