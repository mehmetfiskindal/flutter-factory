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

  factory AppEnvironment.fromEnvironment() {
    const flavorName = String.fromEnvironment(
      'FLAVOR',
      defaultValue: 'dev',
    );
    final flavor = AppFlavor.fromName(flavorName);

    return AppEnvironment(
      flavor: flavor,
      appName: const String.fromEnvironment(
        'APP_NAME',
        defaultValue: '{{app_name.titleCase()}} Dev',
      ),
      apiBaseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.dev.example.com',
      ),
      enableNetworkLogs: const bool.fromEnvironment(
        'ENABLE_NETWORK_LOGS',
        defaultValue: true,
      ),
      showDebugBanner: const bool.fromEnvironment(
        'SHOW_DEBUG_BANNER',
        defaultValue: true,
      ),
    );
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
