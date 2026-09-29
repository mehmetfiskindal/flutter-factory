import 'package:mason/mason.dart';

void run(HookContext context) {
  final routePath = (context.vars['route_path'] as String?)?.trim();
  final name = context.vars['name'] as String;
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
    'is_riverpod': !isBloc && !isNative,
    'is_bloc': isBloc,
    'is_native': isNative,
    'state_folder': isBloc
        ? 'controllers'
        : isNative
            ? 'viewmodels'
            : 'providers',
    'state_suffix': isBloc
        ? 'cubit'
        : isNative
            ? 'view_model'
            : 'controller',
    'route_path': routePath == null || routePath.isEmpty
        ? '/${name.replaceAll('_', '-')}'
        : routePath,
  };
}
