import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../app/flavor.dart';

final appLoggerProvider = Provider<Logger>((ref) {
  final environment = ref.watch(appEnvironmentProvider);

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
});
