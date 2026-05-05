{{#is_riverpod}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{/is_riverpod}}
import 'package:logger/logger.dart';

import '../../app/flavor.dart';

{{#is_riverpod}}
final appLoggerProvider = Provider<Logger>((ref) {
  final environment = ref.watch(appEnvironmentProvider);

  return createAppLogger(environment);
});
{{/is_riverpod}}
Logger createAppLogger(AppEnvironment environment) {
  return Logger(
    level: environment.isProduction ? Level.warning : Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 100,
      colors: false,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
}
