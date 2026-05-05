import 'package:flutter/material.dart';
{{#is_riverpod}}
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{/is_riverpod}}{{#is_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
{{/is_bloc}}

import '../core/theme/app_theme.dart';
import 'flavor.dart';
import 'router.dart';
{{#is_bloc}}import '../features/auth/presentation/controllers/auth_bloc.dart';
{{/is_bloc}}

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
    final authBloc = context.read<AuthBloc>();
    final environment = context.read<AppEnvironment>();
    final router = createAppRouter(authBloc);

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
