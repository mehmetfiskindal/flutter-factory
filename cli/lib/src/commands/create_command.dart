import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../config/flutter_factory_config.dart';
import '../generator/mason_service.dart';
import '../utils/name_validator.dart';

class CreateCommand extends Command<int> {
  CreateCommand({
    required Logger logger,
    required MasonService masonService,
  })  : _logger = logger,
        _masonService = masonService {
    argParser
      ..addOption(
        'state',
        allowed: const ['riverpod', 'bloc'],
        help: 'State management solution.',
      )
      ..addOption(
        'backend',
        allowed: const ['rest_firebase_hybrid'],
        help: 'Backend preset.',
      )
      ..addFlag(
        'auth',
        help: 'Generate authentication scaffolding.',
      )
      ..addFlag(
        'offline',
        help: 'Generate offline support scaffolding.',
      );
  }

  final Logger _logger;
  final MasonService _masonService;

  @override
  String get description => 'Create a new production-ready Flutter project.';

  @override
  String get invocation =>
      'flutter_factory create <app_name> [--state riverpod|bloc] [--auth] [--offline]';

  @override
  String get name => 'create';

  @override
  Future<int> run() async {
    final appName = argResults?.rest.singleOrNull;
    if (appName == null) {
      throw UsageException('Missing <app_name>.', usage);
    }

    validateDartIdentifier(appName, label: 'app_name');

    final config = FlutterFactoryConfig.load();
    final stateManagement =
        argResults?['state'] as String? ?? config.stateManagement ?? 'riverpod';
    final backend = argResults?['backend'] as String? ??
        config.backend ??
        'rest_firebase_hybrid';
    final includeAuth = argResults?['auth'] as bool? ?? config.auth;
    final includeOffline = argResults?['offline'] as bool? ?? config.offline;

    _logger.info('Creating Flutter project "$appName"...');

    await _masonService.generate(
      brickName: 'starter',
      targetDirectory: appName,
      vars: {
        'app_name': appName,
        'state_management': stateManagement,
        'backend': backend,
        'auth': includeAuth,
        'offline_support': includeOffline,
      },
    );

    _logger.success('Project "$appName" generated.');
    return ExitCode.success.code;
  }
}
