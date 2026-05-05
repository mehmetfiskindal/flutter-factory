import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/di.dart';
import 'app/flavor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = AppEnvironment.fromFlavor(AppFlavor.current);
  final container = await configureDependencies(environment);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const {{app_name.pascalCase()}}Application(),
    ),
  );
}
