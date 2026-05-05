import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_factory/flutter_factory.dart';
import 'package:flutter_factory/src/commands/create_command.dart';
import 'package:flutter_factory/src/generator/mason_service.dart';
import 'package:mason_logger/mason_logger.dart';
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

  test('doctor command is available', () async {
    final exitCode = await runFlutterFactory(['doctor']);

    expect(exitCode, anyOf(0, 70));
  });

  test('create passes bloc state to the starter brick', () async {
    final masonService = _RecordingMasonService();
    final createdShells = <({String appName, String organization})>[];
    final runner = CommandRunner<int>('test', 'test')
      ..addCommand(
        CreateCommand(
          logger: Logger(),
          masonService: masonService,
          flutterShellCreator: ({
            required appName,
            required organization,
          }) async {
            createdShells.add((
              appName: appName,
              organization: organization,
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
  });
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
