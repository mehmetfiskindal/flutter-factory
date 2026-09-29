import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_factory/flutter_factory.dart';
import 'package:flutter_factory/src/commands/config_command.dart';
import 'package:flutter_factory/src/commands/add_command.dart';
import 'package:flutter_factory/src/commands/create_command.dart';
import 'package:flutter_factory/src/commands/doctor_command.dart';
import 'package:flutter_factory/src/commands/verify_command.dart';
import 'package:flutter_factory/src/config/flutter_factory_config.dart';
import 'package:flutter_factory/src/generator/mason_service.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory previousDirectory;
  late Directory tempDirectory;

  setUp(() {
    previousDirectory = Directory.current;
    tempDirectory =
        Directory.systemTemp.createTempSync('flutter_factory_test_');
    Directory.current = tempDirectory;
  });

  tearDown(() {
    Directory.current = previousDirectory;
    tempDirectory.deleteSync(recursive: true);
  });

  test('prints version', () async {
    final exitCode = await runFlutterFactory(['--version']);

    expect(exitCode, 0);
  });

  test('create requires an app name', () async {
    final exitCode = await runFlutterFactory(['create']);

    expect(exitCode, 64);
  });

  test('add feature prevents existing feature conflicts by default', () async {
    Directory('lib/features/auth').createSync(recursive: true);

    final exitCode = await runFlutterFactory([
      'add',
      'feature',
      'auth',
    ]);

    expect(exitCode, 64);
  });

  test('add page prevents existing file conflicts by default', () async {
    File('lib/features/profile/presentation/views/dashboard_view.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync('// existing');

    final exitCode = await runFlutterFactory([
      'add',
      'page',
      'dashboard',
      '--feature',
      'profile',
    ]);

    expect(exitCode, 64);
  });

  test('add page wires route constants and shell route markers', () async {
    _createGeneratedRouterFiles();
    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddPageCommand(
          logger: Logger(),
          masonService: masonService,
        ),
      );

    final exitCode = await runner.run([
      'page',
      'dashboard',
      '--feature',
      'profile',
    ]);

    expect(exitCode, 0);
    expect(masonService.brickName, 'page');
    expect(masonService.vars['name'], 'dashboard');
    expect(masonService.vars['feature'], 'profile');
    expect(masonService.vars['state_management'], 'riverpod');

    final routePaths = File(
      'lib/core/router/route_paths.dart',
    ).readAsStringSync();
    final router = File('lib/app/router.dart').readAsStringSync();

    expect(routePaths, contains("static const dashboard = '/dashboard';"));
    expect(routePaths, contains("static const dashboard = 'dashboard';"));
    expect(
      router,
      contains(
        "import '../features/profile/presentation/routes/dashboard_route.dart';",
      ),
    );
    expect(router, contains('DashboardRoute.route(),'));
  });

  test('add page route wiring is idempotent', () async {
    _createGeneratedRouterFiles();
    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddPageCommand(
          logger: Logger(),
          masonService: masonService,
        ),
      );

    for (var i = 0; i < 2; i += 1) {
      final exitCode = await runner.run([
        'page',
        'dashboard',
        '--feature',
        'profile',
        '--force',
      ]);
      expect(exitCode, 0);
    }

    final routePaths = File(
      'lib/core/router/route_paths.dart',
    ).readAsStringSync();
    final router = File('lib/app/router.dart').readAsStringSync();

    expect(
        _countOccurrences(routePaths, "static const dashboard = '/dashboard';"),
        1);
    expect(
      _countOccurrences(
        router,
        "import '../features/profile/presentation/routes/dashboard_route.dart';",
      ),
      1,
    );
    expect(_countOccurrences(router, 'DashboardRoute.route(),'), 1);
  });

  test('add page supports custom route path', () async {
    _createGeneratedRouterFiles();
    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddPageCommand(
          logger: Logger(),
          masonService: masonService,
        ),
      );

    final exitCode = await runner.run([
      'page',
      'dashboard',
      '--feature',
      'profile',
      '--path',
      '/profile/dashboard',
    ]);

    expect(exitCode, 0);
    expect(masonService.vars['route_path'], '/profile/dashboard');

    final routePaths = File(
      'lib/core/router/route_paths.dart',
    ).readAsStringSync();
    expect(
      routePaths,
      contains("static const dashboard = '/profile/dashboard';"),
    );
  });

  test('add page can skip route auto-wire', () async {
    _createGeneratedRouterFiles();
    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddPageCommand(
          logger: Logger(),
          masonService: masonService,
        ),
      );

    final exitCode = await runner.run([
      'page',
      'dashboard',
      '--feature',
      'profile',
      '--no-route',
    ]);

    expect(exitCode, 0);

    final router = File('lib/app/router.dart').readAsStringSync();
    expect(router, isNot(contains('DashboardRoute.route(),')));
  });

  test('add page passes the selected state management solution', () async {
    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddPageCommand(
          logger: Logger(),
          masonService: masonService,
        ),
      );

    final exitCode = await runner.run([
      'page',
      'dashboard',
      '--feature',
      'profile',
      '--state',
      'bloc',
      '--no-route',
    ]);

    expect(exitCode, 0);
    expect(masonService.vars['state_management'], 'bloc');
  });

  test('add api passes the selected state management solution', () async {
    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddApiCommand(
          logger: Logger(),
          masonService: masonService,
        ),
      );

    final exitCode = await runner.run([
      'api',
      'billing',
      '--state',
      'bloc',
      '--no-codegen',
    ]);

    expect(exitCode, 0);
    expect(masonService.vars['state_management'], 'bloc');
  });

  test('add commands accept native Flutter SDK state management', () async {
    final featureService = _RecordingMasonService();
    final featureRunner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddFeatureCommand(
          logger: Logger(),
          masonService: featureService,
        ),
      );
    expect(
      await featureRunner.run(['feature', 'profile', '--state', 'native']),
      0,
    );
    expect(featureService.vars['state_management'], 'native');

    final pageService = _RecordingMasonService();
    final pageRunner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddPageCommand(
          logger: Logger(),
          masonService: pageService,
        ),
      );
    expect(
      await pageRunner.run([
        'page',
        'dashboard',
        '--feature',
        'profile',
        '--state',
        'native',
        '--no-route',
      ]),
      0,
    );
    expect(pageService.vars['state_management'], 'native');

    final apiService = _RecordingMasonService();
    final apiRunner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddApiCommand(
          logger: Logger(),
          masonService: apiService,
        ),
      );
    expect(
      await apiRunner.run([
        'api',
        'billing',
        '--state',
        'native',
        '--no-codegen',
      ]),
      0,
    );
    expect(apiService.vars['state_management'], 'native');
  });

  test('add api rejects Firebase-only project defaults', () async {
    const config = FlutterFactoryConfig(backend: 'firebase');
    config.save();

    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddApiCommand(
          logger: Logger(),
          masonService: _RecordingMasonService(),
        ),
      );

    expect(
      runner.run(['api', 'billing']),
      throwsA(isA<UsageException>()),
    );
  });

  test('add page and API default to the project state management setting',
      () async {
    const config = FlutterFactoryConfig(stateManagement: 'bloc');
    config.save();

    final pageService = _RecordingMasonService();
    final pageRunner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddPageCommand(
          logger: Logger(),
          masonService: pageService,
        ),
      );
    final pageExitCode = await pageRunner.run([
      'page',
      'dashboard',
      '--feature',
      'profile',
      '--no-route',
    ]);

    final apiService = _RecordingMasonService();
    final apiRunner = CommandRunner<int>('test', 'test')
      ..addCommand(
        AddApiCommand(
          logger: Logger(),
          masonService: apiService,
        ),
      );
    final apiExitCode = await apiRunner.run([
      'api',
      'billing',
      '--no-codegen',
    ]);

    expect(pageExitCode, 0);
    expect(pageService.vars['state_management'], 'bloc');
    expect(apiExitCode, 0);
    expect(apiService.vars['state_management'], 'bloc');
  });

  test('doctor command is available', () async {
    final exitCode = await runFlutterFactory(['doctor']);

    expect(exitCode, anyOf(0, 70));
  });

  test('create passes bloc state and firebase backend to the starter brick',
      () async {
    final masonService = _RecordingMasonService();
    final createdShells = <({String appName, String organization, List<String>? platforms})>[];
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        CreateCommand(
          logger: Logger(),
          masonService: masonService,
          flutterShellCreator: ({
            required appName,
            required organization,
            platforms,
          }) async {
            createdShells.add((
              appName: appName,
              organization: organization,
              platforms: platforms,
            ));
          },
        ),
      );

    final exitCode = await runner.run([
      'create',
      'bloc_app',
      '--org',
      'com.example',
      '--state',
      'bloc',
      '--backend',
      'firebase',
    ]);

    expect(exitCode, 0);
    expect(createdShells.single.appName, 'bloc_app');
    expect(createdShells.single.organization, 'com.example');
    expect(masonService.brickName, 'starter');
    expect(masonService.targetDirectory, 'bloc_app');
    expect(masonService.force, isTrue);
    expect(masonService.vars['app_name'], 'bloc_app');
    expect(masonService.vars['org_name'], 'com.example');
    expect(masonService.vars['state_management'], 'bloc');
    expect(masonService.vars['backend'], 'firebase');
  });

  test('create passes native Flutter SDK state to the starter brick', () async {
    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        CreateCommand(
          logger: Logger(),
          masonService: masonService,
          flutterShellCreator: ({
            required appName,
            required organization,
            platforms,
          }) async {},
        ),
      );

    final exitCode = await runner.run([
      'create',
      'native_app',
      '--org',
      'com.example',
      '--state',
      'native',
    ]);

    expect(exitCode, 0);
    expect(masonService.vars['state_management'], 'native');
  });

  test('create passes auth and offline flags to the starter brick', () async {
    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        CreateCommand(
          logger: Logger(),
          masonService: masonService,
          flutterShellCreator: ({
            required appName,
            required organization,
            platforms,
          }) async {},
        ),
      );

    final exitCode = await runner.run([
      'create',
      'offline_auth_app',
      '--org',
      'com.example',
      '--auth',
      '--offline',
    ]);

    expect(exitCode, 0);
    expect(masonService.vars['auth'], isTrue);
    expect(masonService.vars['offline_support'], isTrue);
  });

  test('create CLI arguments override config defaults', () async {
    const config = FlutterFactoryConfig(
      stateManagement: 'bloc',
      backend: 'firebase',
      organization: 'com.config',
      auth: true,
      offline: true,
    );
    config.save();

    final masonService = _RecordingMasonService();
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        CreateCommand(
          logger: Logger(),
          masonService: masonService,
          flutterShellCreator: ({
            required appName,
            required organization,
            platforms,
          }) async {},
        ),
      );

    final exitCode = await runner.run([
      'create',
      'override_app',
      '--org',
      'com.cli',
      '--state',
      'riverpod',
      '--backend',
      'rest_firebase_hybrid',
      '--no-auth',
      '--no-offline',
    ]);

    expect(exitCode, 0);
    expect(masonService.vars['org_name'], 'com.cli');
    expect(masonService.vars['state_management'], 'riverpod');
    expect(masonService.vars['backend'], 'rest_firebase_hybrid');
    expect(masonService.vars['auth'], isFalse);
    expect(masonService.vars['offline_support'], isFalse);
  });

  test('create passes platforms option to flutterShellCreator and validates input', () async {
    final masonService = _RecordingMasonService();
    final createdShells = <({String appName, String organization, List<String>? platforms})>[];
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        CreateCommand(
          logger: Logger(),
          masonService: masonService,
          flutterShellCreator: ({
            required appName,
            required organization,
            platforms,
          }) async {
            createdShells.add((
              appName: appName,
              organization: organization,
              platforms: platforms,
            ));
          },
        ),
      );

    final exitCode1 = await runner.run([
      'create',
      'test_app',
      '--platforms',
      'android,ios',
    ]);

    expect(exitCode1, 0);
    expect(createdShells.single.platforms, ['android', 'ios']);

    expect(
      runner.run([
        'create',
        'test_app',
        '--platforms',
        'android,invalid_platform',
      ]),
      throwsA(isA<UsageException>()),
    );
  });

  test('starter brick supports all state/backend/auth/offline combinations',
      () async {
    final repoRoot = previousDirectory.parent.path;
    final masonService = MasonService(
      logger: Logger(),
      workingDirectory: Directory(repoRoot),
    );

    for (final stateManagement in ['riverpod', 'bloc', 'native']) {
      for (final backend in ['rest_firebase_hybrid', 'firebase']) {
        for (final includeAuth in [true, false]) {
          for (final includeOffline in [true, false]) {
            final outputDirectory = Directory(
              p.join(
                tempDirectory.path,
                [
                  stateManagement,
                  backend,
                  includeAuth ? 'auth' : 'no_auth',
                  includeOffline ? 'offline' : 'online',
                ].join('_'),
              ),
            );

            await masonService.generate(
              brickName: 'starter',
              targetDirectory: outputDirectory.path,
              force: true,
              vars: {
                'app_name': 'sample_app',
                'org_name': 'com.example',
                'state_management': stateManagement,
                'backend': backend,
                'auth': includeAuth,
                'offline_support': includeOffline,
              },
            );

            final files = _generatedFiles(outputDirectory);
            final pubspec = File(p.join(outputDirectory.path, 'pubspec.yaml'))
                .readAsStringSync();
            final router =
                File(p.join(outputDirectory.path, 'lib/app/router.dart'))
                    .readAsStringSync();
            final projectConfig = File(
              p.join(outputDirectory.path, '.flutter_factory.yaml'),
            ).readAsStringSync();

            expect(
              files.any((file) => file.path.contains('{{')),
              isFalse,
              reason: 'Raw mustache marker found in generated file path.',
            );
            expect(
              files.any((file) => file.readAsStringSync().contains('{{')),
              isFalse,
              reason: 'Raw mustache marker found in generated file content.',
            );

            expect(
              Directory(p.join(outputDirectory.path, 'lib/features/auth'))
                  .existsSync(),
              includeAuth,
            );
            expect(router.contains('RoutePaths.signIn'), includeAuth);
            expect(router.contains('SignInView'), includeAuth);
            expect(
              projectConfig,
              contains('state_management: $stateManagement'),
            );
            expect(projectConfig, contains('backend: $backend'));

            if (stateManagement == 'native') {
              expect(pubspec, isNot(contains('flutter_riverpod:')));
              expect(pubspec, isNot(contains('flutter_bloc:')));
              expect(pubspec, isNot(contains('bloc:')));
              final main = File(
                p.join(outputDirectory.path, 'lib/main.dart'),
              ).readAsStringSync();
              expect(main, isNot(contains('flutter_riverpod')));
              expect(main, isNot(contains('flutter_bloc')));
              if (includeAuth) {
                final authViewModel = File(
                  p.join(
                    outputDirectory.path,
                    'lib/features/auth/presentation/viewmodels/auth_view_model.dart',
                  ),
                ).readAsStringSync();
                expect(authViewModel, contains('extends ChangeNotifier'));
                expect(authViewModel, isNot(contains('flutter_riverpod')));
                expect(authViewModel, isNot(contains('package:bloc/')));
              }
            }

            if (backend == 'firebase') {
              expect(pubspec.contains('firebase_auth:'), includeAuth);
            }

            if (backend == 'rest_firebase_hybrid') {
              expect(pubspec.contains('connectivity_plus:'), includeOffline);
              expect(
                Directory(p.join(outputDirectory.path, 'lib/core/offline'))
                    .existsSync(),
                includeOffline,
              );
            }
          }
        }
      }
    }
  });

  test('feature, page, and API bricks generate state-compatible files',
      () async {
    final repoRoot = previousDirectory.parent.path;
    final masonService = MasonService(
      logger: Logger(),
      workingDirectory: Directory(repoRoot),
    );

    for (final stateManagement in ['riverpod', 'bloc', 'native']) {
      final outputDirectory = Directory(
        p.join(tempDirectory.path, 'additional_bricks_$stateManagement'),
      );

      await masonService.generate(
        brickName: 'api_service',
        targetDirectory: outputDirectory.path,
        force: true,
        vars: {
          'name': 'billing',
          'endpoint': '/v1/billing',
          'state_management': stateManagement,
          'run_codegen': false,
        },
      );
      await masonService.generate(
        brickName: 'feature',
        targetDirectory: outputDirectory.path,
        force: true,
        vars: {
          'name': 'profile',
          'state_management': stateManagement,
        },
      );
      await masonService.generate(
        brickName: 'page',
        targetDirectory: outputDirectory.path,
        force: true,
        vars: {
          'name': 'dashboard',
          'feature': 'profile',
          'state_management': stateManagement,
        },
      );

      final files = _generatedFiles(outputDirectory);
      expect(
        files.any((file) => file.path.contains('{{')),
        isFalse,
        reason: 'Raw mustache marker found in generated file path.',
      );
      expect(
        files.any((file) => file.readAsStringSync().contains('{{')),
        isFalse,
        reason: 'Raw mustache marker found in generated file content.',
      );

      final apiDirectory =
          Directory(p.join(outputDirectory.path, 'lib/features/billing'));
      final pageView = File(
        p.join(
          outputDirectory.path,
          'lib/features/profile/presentation/views/dashboard_view.dart',
        ),
      ).readAsStringSync();

      if (stateManagement == 'bloc') {
        expect(
          File(p.join(apiDirectory.path, 'dependencies.dart')).existsSync(),
          isTrue,
        );
        expect(
          File(p.join(apiDirectory.path, 'providers.dart')).existsSync(),
          isFalse,
        );
        expect(
          pageView,
          contains("import 'package:flutter_bloc/flutter_bloc.dart';"),
        );
        expect(pageView, isNot(contains('flutter_riverpod')));
        expect(
          File(
            p.join(
              outputDirectory.path,
              'lib/features/profile/presentation/controllers/dashboard_cubit.dart',
            ),
          ).existsSync(),
          isTrue,
        );
      } else if (stateManagement == 'native') {
        final apiDependencies = File(
          p.join(apiDirectory.path, 'dependencies.dart'),
        ).readAsStringSync();
        expect(
          File(p.join(apiDirectory.path, 'dependencies.dart')).existsSync(),
          isTrue,
        );
        expect(
          File(p.join(apiDirectory.path, 'providers.dart')).existsSync(),
          isFalse,
        );
        expect(pageView, contains('ListenableBuilder'));
        expect(pageView, isNot(contains('flutter_riverpod')));
        expect(pageView, isNot(contains('flutter_bloc')));
        expect(apiDependencies, isNot(contains('flutter_riverpod')));
        expect(apiDependencies, isNot(contains('flutter_bloc')));
        expect(apiDependencies, isNot(contains('package:bloc/')));
        expect(
          File(
            p.join(
              outputDirectory.path,
              'lib/features/profile/presentation/viewmodels/dashboard_view_model.dart',
            ),
          ).existsSync(),
          isTrue,
        );

        final featureView = File(
          p.join(
            outputDirectory.path,
            'lib/features/profile/presentation/views/profile_view.dart',
          ),
        ).readAsStringSync();
        expect(featureView, contains('ListenableBuilder'));
        final featureViewModel = File(
          p.join(
            outputDirectory.path,
            'lib/features/profile/presentation/viewmodels/profile_view_model.dart',
          ),
        );
        expect(featureViewModel.existsSync(), isTrue);
        expect(
          featureViewModel.readAsStringSync(),
          isNot(contains('flutter_riverpod')),
        );
      } else {
        expect(
          File(p.join(apiDirectory.path, 'providers.dart')).existsSync(),
          isTrue,
        );
        expect(
          File(p.join(apiDirectory.path, 'dependencies.dart')).existsSync(),
          isFalse,
        );
        expect(pageView, contains('flutter_riverpod'));
        expect(
          File(
            p.join(
              outputDirectory.path,
              'lib/features/profile/presentation/providers/dashboard_controller.dart',
            ),
          ).existsSync(),
          isTrue,
        );
      }
    }
  });

  test('verify command generates starter samples without analyze', () async {
    final repoRoot = previousDirectory.parent.path;
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        VerifyCommand(
          logger: Logger(),
          masonService: MasonService(
            logger: Logger(),
            workingDirectory: Directory(repoRoot),
          ),
          tempDirectoryFactory: () => tempDirectory,
        ),
      );

    final exitCode = await runner.run(['verify', '--no-analyze']);

    expect(exitCode, 0);
    expect(
      Directory(
        p.join(
          tempDirectory.path,
          'riverpod_rest_firebase_hybrid_auth_offline',
        ),
      ).existsSync(),
      isTrue,
    );
  });

  test('normalizes firebase backend config values', () {
    expect(normalizeBackendPreset('Firebase'), 'firebase');
    expect(normalizeBackendPreset('firebase'), 'firebase');
    expect(
      normalizeBackendPreset('REST + Firebase hybrid'),
      'rest_firebase_hybrid',
    );
    expect(normalizeBackendPreset(null), 'rest_firebase_hybrid');
  });

  test('doctor firebase checks pass when tooling is available', () async {
    _createFlutterFactoryRoot();
    final exitCode = await _runDoctorWith({
      'dart --version': _success('Dart SDK version: 3.11.5'),
      'flutter --version': _success('Flutter 3.41.9'),
      'mason --version': _success('mason_cli 0.1.3'),
      'node --version': _success('v20.0.0'),
      'npm --version': _success('10.0.0'),
      'firebase --version': _success('15.0.0'),
      'flutterfire --version': _success('1.3.2'),
      'firebase login:list': _success('Logged in as user@example.com'),
    });

    expect(exitCode, 0);
  });

  test('doctor firebase fails when firebase CLI is missing', () async {
    _createFlutterFactoryRoot();
    final exitCode = await _runDoctorWith({
      'dart --version': _success('Dart SDK version: 3.11.5'),
      'flutter --version': _success('Flutter 3.41.9'),
      'mason --version': _success('mason_cli 0.1.3'),
      'node --version': _success('v20.0.0'),
      'npm --version': _success('10.0.0'),
      'flutterfire --version': _success('1.3.2'),
    });

    expect(exitCode, 70);
  });

  test('doctor firebase fails when flutterfire CLI is missing', () async {
    _createFlutterFactoryRoot();
    final exitCode = await _runDoctorWith({
      'dart --version': _success('Dart SDK version: 3.11.5'),
      'flutter --version': _success('Flutter 3.41.9'),
      'mason --version': _success('mason_cli 0.1.3'),
      'node --version': _success('v20.0.0'),
      'npm --version': _success('10.0.0'),
      'firebase --version': _success('15.0.0'),
      'dart pub global list': _success('mason_cli 0.1.3'),
    });

    expect(exitCode, 70);
  });

  test('doctor firebase fails when node is too old', () async {
    _createFlutterFactoryRoot();
    final exitCode = await _runDoctorWith({
      'dart --version': _success('Dart SDK version: 3.11.5'),
      'flutter --version': _success('Flutter 3.41.9'),
      'mason --version': _success('mason_cli 0.1.3'),
      'node --version': _success('v16.20.0'),
      'npm --version': _success('10.0.0'),
      'firebase --version': _success('15.0.0'),
      'flutterfire --version': _success('1.3.2'),
    });

    expect(exitCode, 70);
  });
}

Future<int> _runDoctorWith(Map<String, ProcessResult> results) {
  final runner = CommandRunner<int>('test', 'test')
    ..addCommand(
      DoctorCommand(
        logger: Logger(),
        processRunner: (executable, args) async {
          final key = '$executable ${args.join(' ')}';
          final result = results[key];
          if (result == null) {
            throw ProcessException(executable, args, 'not found');
          }

          return result;
        },
      ),
    );

  return runner.run(['doctor', '--firebase']).then((value) => value ?? 0);
}

ProcessResult _success(String stdout) {
  return ProcessResult(42, 0, stdout, '');
}

void _createFlutterFactoryRoot() {
  File('mason.yaml')
    ..createSync(recursive: true)
    ..writeAsStringSync('bricks: {}\n');
  for (final path in [
    'starter/brick.yaml',
    'bricks/feature/brick.yaml',
    'bricks/api_service/brick.yaml',
    'bricks/page/brick.yaml',
    'bricks/usecase/brick.yaml',
    'bricks/widget/brick.yaml',
  ]) {
    File(path)
      ..createSync(recursive: true)
      ..writeAsStringSync('name: test\n');
  }
}

void _createGeneratedRouterFiles() {
  File('lib/core/router/route_paths.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
abstract final class RoutePaths {
  static const home = '/home';
  static const settings = '/settings';
  // flutter_factory: route-paths-start
  // flutter_factory: route-paths-end
}

abstract final class RouteNames {
  static const home = 'home';
  static const settings = 'settings';
  // flutter_factory: route-names-start
  // flutter_factory: route-names-end
}
''');

  File('lib/app/router.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
import '../features/home/presentation/views/home_view.dart';
import '../features/settings/presentation/views/settings_view.dart';
// flutter_factory: route-imports-start
// flutter_factory: route-imports-end

final routes = [
  HomeRoute.route(),
  SettingsRoute.route(),
  // flutter_factory: shell-routes-start
  // flutter_factory: shell-routes-end
];
''');
}

class _RecordingMasonService extends MasonService {
  _RecordingMasonService() : super(logger: Logger());

  late String brickName;
  late Map<String, dynamic> vars;
  String? targetDirectory;
  late bool force;

  @override
  Future<void> generate({
    required String brickName,
    required Map<String, dynamic> vars,
    String? targetDirectory,
    bool force = false,
  }) async {
    this.brickName = brickName;
    this.vars = Map<String, dynamic>.of(vars);
    this.targetDirectory = targetDirectory;
    this.force = force;
  }
}

List<File> _generatedFiles(Directory directory) {
  return directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => !p.basename(file.path).endsWith('.lock'))
      .toList();
}

int _countOccurrences(String content, String pattern) {
  return pattern.allMatches(content).length;
}
