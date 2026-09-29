import 'package:flutter/material.dart';
{{#is_riverpod}}
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{/is_riverpod}}{{#is_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
{{/is_bloc}}

import '../core/theme/app_theme.dart';
{{^is_native}}import 'flavor.dart';
{{/is_native}}
import 'router.dart';
{{#is_bloc}}{{#include_auth}}import '../features/auth/presentation/controllers/auth_bloc.dart';
{{/include_auth}}
{{/is_bloc}}
{{#is_native}}import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'di.dart';
{{#include_auth}}import '../features/auth/presentation/viewmodels/auth_view_model.dart';
{{/include_auth}}{{/is_native}}

{{#is_riverpod}}
class {{app_name.pascalCase()}}Application extends ConsumerWidget {
  const {{app_name.pascalCase()}}Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final environment = ref.watch(appEnvironmentProvider);

    return MaterialApp.router(
      title: environment.appName,
      debugShowCheckedModeBanner: environment.showDebugBanner,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
    );
  }
}
{{/is_riverpod}}{{#is_bloc}}
class {{app_name.pascalCase()}}Application extends StatelessWidget {
  const {{app_name.pascalCase()}}Application({super.key});

  @override
  Widget build(BuildContext context) {
    {{#include_auth}}
    final authBloc = context.read<AuthBloc>();
    {{/include_auth}}
    final environment = context.read<AppEnvironment>();
    final router = createAppRouter({{#include_auth}}authBloc{{/include_auth}});

    return MaterialApp.router(
      title: environment.appName,
      debugShowCheckedModeBanner: environment.showDebugBanner,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
    );
  }
}
{{/is_bloc}}
{{#is_native}}
class {{app_name.pascalCase()}}Application extends StatefulWidget {
  const {{app_name.pascalCase()}}Application({
    required this.dependencies,
    {{#include_auth}}required this.authViewModel,
    {{/include_auth}}super.key,
  });

  final AppDependencies dependencies;
  {{#include_auth}}final AuthViewModel authViewModel;
  {{/include_auth}}

  @override
  State<{{app_name.pascalCase()}}Application> createState() =>
      _{{app_name.pascalCase()}}ApplicationState();
}

class _{{app_name.pascalCase()}}ApplicationState
    extends State<{{app_name.pascalCase()}}Application> {
  late final GoRouter _router = createAppRouter(
    widget.dependencies,
    {{#include_auth}}widget.authViewModel,{{/include_auth}}
  );

  @override
  void dispose() {
    _router.dispose();
    {{#include_auth}}widget.authViewModel.dispose();
    {{/include_auth}}super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final environment = widget.dependencies.environment;

    return MaterialApp.router(
      title: environment.appName,
      debugShowCheckedModeBanner: environment.showDebugBanner,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: _router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
    );
  }
}
{{/is_native}}
