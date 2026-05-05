import 'package:mason_logger/mason_logger.dart';

import 'src/command_runner.dart';

Future<int> runFlutterFactory(
  List<String> arguments, {
  Logger? logger,
}) {
  return FlutterFactoryCommandRunner(
    logger: logger ?? Logger(),
  ).run(arguments);
}
