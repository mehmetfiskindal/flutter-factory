import 'package:mason/mason.dart';

void run(HookContext context) {
  final stateManagement = (context.vars['state_management'] as String?)
      ?.trim()
      .toLowerCase();
  final isBloc = stateManagement == 'bloc';
  final normalizedStateManagement = isBloc ? 'bloc' : 'riverpod';

  context.vars = {
    ...context.vars,
    'state_management': normalizedStateManagement,
    'is_riverpod': normalizedStateManagement == 'riverpod',
    'is_bloc': normalizedStateManagement == 'bloc',
    'state_folder': normalizedStateManagement == 'bloc'
        ? 'controllers'
        : 'providers',
  };
}
