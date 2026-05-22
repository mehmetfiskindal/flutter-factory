import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../config/flutter_factory_config.dart';
import '../generator/mason_service.dart';
import '../utils/name_validator.dart';

typedef FlutterShellCreator = Future<void> Function({
  required String appName,
  required String organization,
  List<String>? platforms,
});

class CreateCommand extends Command<int> {
  CreateCommand({
    required Logger logger,
    required MasonService masonService,
    FlutterShellCreator? flutterShellCreator,
  })  : _logger = logger,
        _masonService = masonService,
        _flutterShellCreator = flutterShellCreator ?? createFlutterShell {
    argParser
      ..addOption(
        'state',
        allowed: const ['riverpod', 'bloc'],
        help: 'State management solution.',
      )
      ..addOption(
        'backend',
        allowed: const ['rest_firebase_hybrid', 'firebase'],
        help: 'Backend preset.',
      )
      ..addOption(
        'org',
        help: 'Reverse-domain organization id, for example com.fiskindal.',
      )
      ..addFlag(
        'auth',
        help: 'Generate authentication scaffolding.',
      )
      ..addFlag(
        'offline',
        help: 'Generate offline support scaffolding.',
      )
      ..addOption(
        'platforms',
        help: 'The platforms to support. (comma-separated: android, ios, web, macos, linux, windows)',
      );
  }

  final Logger _logger;
  final MasonService _masonService;
  final FlutterShellCreator _flutterShellCreator;

  @override
  String get description => 'Create a new production-ready Flutter project.';

  @override
  String get invocation =>
      'flutter_factory create <app_name> [--org com.example] [--state riverpod|bloc] [--backend rest_firebase_hybrid|firebase] [--auth] [--offline]';

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
    final organization =
        argResults?['org'] as String? ?? config.organization ?? 'com.example';
    validateReverseDomain(organization, label: 'org');

final stateManagement =
        argResults?['state'] as String? ?? config.stateManagement ?? 'riverpod';
    final backend = argResults?['backend'] as String? ??
        config.backend ??
        'rest_firebase_hybrid';
    final includeAuth = argResults?['auth'] as bool? ?? config.auth;
    final includeOffline = argResults?['offline'] as bool? ?? config.offline;

    final platformsString = argResults?['platforms'] as String?;
    final List<String>? platforms = platformsString != null
        ? platformsString
            .split(',')
            .map((p) => p.trim().toLowerCase())
            .where((p) => p.isNotEmpty)
            .toList()
        : null;

    const validPlatforms = {
      'android',
      'ios',
      'web',
      'macos',
      'linux',
      'windows'
    };
    if (platforms != null) {
      for (final platform in platforms) {
        if (!validPlatforms.contains(platform)) {
          throw UsageException(
            'Invalid platform: "$platform". Valid platforms are: ${validPlatforms.join(', ')}',
            usage,
          );
        }
      }
    }

    _logger.info('Creating Flutter project "$appName"...');
    await _flutterShellCreator(
      appName: appName,
      organization: organization,
      platforms: platforms,
    );

    await _masonService.generate(
      brickName: 'starter',
      targetDirectory: appName,
      force: true,
      vars: {
        'app_name': appName,
        'org_name': organization,
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

Future<void> createFlutterShell({
  required String appName,
  required String organization,
  List<String>? platforms,
}) async {
  final args = ['create', '--org', organization];
  if (platforms != null && platforms.isNotEmpty) {
    args.addAll(['--platforms', platforms.join(',')]);
  }
  args.add(appName);

  final result = await Process.run(
    'flutter',
    args,
    runInShell: true,
  );

  if (result.exitCode != ExitCode.success.code) {
    throw UsageException(
      'flutter create failed:\n${result.stderr}',
      'flutter_factory create <app_name> [--org com.example] [--state riverpod|bloc] [--backend rest_firebase_hybrid|firebase] [--auth] [--offline] [--platforms android,ios]',
    );
  }
}
