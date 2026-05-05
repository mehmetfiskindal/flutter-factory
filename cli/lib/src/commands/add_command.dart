import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../config/flutter_factory_config.dart';
import '../generator/mason_service.dart';
import '../utils/name_validator.dart';

class AddCommand extends Command<int> {
  AddCommand({
    required Logger logger,
    required MasonService masonService,
  }) {
    addSubcommand(AddFeatureCommand(
      logger: logger,
      masonService: masonService,
    ));
    addSubcommand(AddApiCommand(
      logger: logger,
      masonService: masonService,
    ));
    addSubcommand(AddPageCommand(
      logger: logger,
      masonService: masonService,
    ));
  }

  @override
  String get description =>
      'Add generated building blocks to a Flutter project.';

  @override
  String get name => 'add';
}

class AddFeatureCommand extends Command<int> {
  AddFeatureCommand({
    required Logger logger,
    required MasonService masonService,
  })  : _logger = logger,
        _masonService = masonService {
    argParser.addOption(
      'state',
      allowed: const ['riverpod', 'bloc'],
      help: 'State management solution for the generated feature.',
    );
  }

  final Logger _logger;
  final MasonService _masonService;

  @override
  String get description => 'Add a feature-first Clean Architecture module.';

  @override
  String get invocation =>
      'flutter_factory add feature <name> [--state riverpod|bloc]';

  @override
  String get name => 'feature';

  @override
  Future<int> run() async {
    final featureName = argResults?.rest.singleOrNull;
    if (featureName == null) {
      throw UsageException('Missing <name>.', usage);
    }

    validateDartIdentifier(featureName, label: 'name');

    final config = FlutterFactoryConfig.load();
    final stateManagement =
        argResults?['state'] as String? ?? config.stateManagement ?? 'riverpod';

    _logger.info('Adding feature "$featureName"...');

    await _masonService.generate(
      brickName: 'feature',
      vars: {
        'name': featureName,
        'state_management': stateManagement,
      },
    );

    _logger.success('Feature "$featureName" generated.');
    return ExitCode.success.code;
  }
}

class AddApiCommand extends Command<int> {
  AddApiCommand({
    required Logger logger,
    required MasonService masonService,
  })  : _logger = logger,
        _masonService = masonService {
    argParser.addOption(
      'endpoint',
      help: 'REST endpoint. Defaults to /<name-param-case>.',
    );
  }

  final Logger _logger;
  final MasonService _masonService;

  @override
  String get description =>
      'Add API service, model, and repository scaffolding.';

  @override
  String get invocation =>
      'flutter_factory add api <name> [--endpoint <endpoint>]';

  @override
  String get name => 'api';

  @override
  Future<int> run() async {
    final apiName = argResults?.rest.singleOrNull;
    if (apiName == null) {
      throw UsageException('Missing <name>.', usage);
    }

    validateDartIdentifier(apiName, label: 'name');

    final endpoint = argResults?['endpoint'] as String?;

    _logger.info('Adding API "$apiName"...');

    await _masonService.generate(
      brickName: 'api_service',
      vars: {
        'name': apiName,
        if (endpoint != null) 'endpoint': endpoint,
      },
    );

    _logger.success('API "$apiName" generated.');
    return ExitCode.success.code;
  }
}

class AddPageCommand extends Command<int> {
  AddPageCommand({
    required Logger logger,
    required MasonService masonService,
  })  : _logger = logger,
        _masonService = masonService {
    argParser.addOption(
      'feature',
      mandatory: true,
      help: 'Target feature name.',
    );
  }

  final Logger _logger;
  final MasonService _masonService;

  @override
  String get description => 'Add a route-ready page inside a feature.';

  @override
  String get invocation =>
      'flutter_factory add page <name> --feature <feature_name>';

  @override
  String get name => 'page';

  @override
  Future<int> run() async {
    final pageName = argResults?.rest.singleOrNull;
    if (pageName == null) {
      throw UsageException('Missing <name>.', usage);
    }

    validateDartIdentifier(pageName, label: 'name');

    final featureName = argResults?['feature'] as String;
    validateDartIdentifier(featureName, label: 'feature');

    _logger.info('Adding page "$pageName" to feature "$featureName"...');

    await _masonService.generate(
      brickName: 'page',
      vars: {
        'name': pageName,
        'feature': featureName,
      },
    );

    _logger.success('Page "$pageName" generated.');
    return ExitCode.success.code;
  }
}
