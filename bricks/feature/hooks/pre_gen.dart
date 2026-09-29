import 'package:mason/mason.dart';

void run(HookContext context) {
  final stateManagement = (context.vars['state_management'] as String?)
      ?.trim()
      .toLowerCase();
  final isBloc = stateManagement == 'bloc';
  final isNative = stateManagement == 'native';
  final normalizedStateManagement = isBloc
      ? 'bloc'
      : isNative
          ? 'native'
          : 'riverpod';

  context.vars = {
    ...context.vars,
    'state_management': normalizedStateManagement,
    'is_riverpod': normalizedStateManagement == 'riverpod',
    'is_bloc': normalizedStateManagement == 'bloc',
    'is_native': isNative,
    'state_folder': isNative
        ? 'viewmodels'
        : isBloc
            ? 'controllers'
            : 'providers',
  };
}
