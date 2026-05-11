import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  if (context.vars['include_auth'] == true) {
    return;
  }

  final authDirectory = Directory(
    'lib/features/auth',
  );

  if (authDirectory.existsSync()) {
    authDirectory.deleteSync(recursive: true);
  }
}
