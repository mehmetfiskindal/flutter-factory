{{#is_riverpod}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{/is_riverpod}}

enum AppFlavor {
  dev,
  staging,
  prod;

  static const _currentName = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static AppFlavor get current => fromName(_currentName);

  static AppFlavor fromName(String value) {
    return switch (value.toLowerCase()) {
      'prod' || 'production' => AppFlavor.prod,
      'staging' || 'stage' => AppFlavor.staging,
      _ => AppFlavor.dev,
    };
  }
}

class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableNetworkLogs,
    required this.showDebugBanner,
  });

  factory AppEnvironment.fromFlavor(AppFlavor flavor) {
    return switch (flavor) {
      AppFlavor.dev => const AppEnvironment(
          flavor: AppFlavor.dev,
          appName: '{{app_name.titleCase()}} Dev',
          apiBaseUrl: String.fromEnvironment(
            'DEV_API_BASE_URL',
            defaultValue: 'https://api.dev.example.com',
          ),
          enableNetworkLogs: true,
          showDebugBanner: true,
        ),
      AppFlavor.staging => const AppEnvironment(
          flavor: AppFlavor.staging,
          appName: '{{app_name.titleCase()}} Staging',
          apiBaseUrl: String.fromEnvironment(
            'STAGING_API_BASE_URL',
            defaultValue: 'https://api.staging.example.com',
          ),
          enableNetworkLogs: true,
          showDebugBanner: true,
        ),
      AppFlavor.prod => const AppEnvironment(
          flavor: AppFlavor.prod,
          appName: '{{app_name.titleCase()}}',
          apiBaseUrl: String.fromEnvironment(
            'PROD_API_BASE_URL',
            defaultValue: 'https://api.example.com',
          ),
          enableNetworkLogs: false,
          showDebugBanner: false,
        ),
    };
  }

  final AppFlavor flavor;
  final String appName;
  final String apiBaseUrl;
  final bool enableNetworkLogs;
  final bool showDebugBanner;

  bool get isProduction => flavor == AppFlavor.prod;
}

{{#is_riverpod}}
final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  throw UnimplementedError('AppEnvironment must be overridden in app/di.dart.');
});
{{/is_riverpod}}
