import 'package:mason/mason.dart';

void run(HookContext context) {
  final stateManagement =
      (context.vars['state_management'] as String?)?.trim().toLowerCase();
  final isBloc = stateManagement == 'bloc';
  final normalizedStateManagement = isBloc ? 'bloc' : 'riverpod';
  final backend = (context.vars['backend'] as String?)?.trim().toLowerCase();
  final isFirebaseBackend = backend == 'firebase';
  final normalizedBackend =
      isFirebaseBackend ? 'firebase' : 'rest_firebase_hybrid';
  final includeAuth = _asBool(context.vars['auth']);
  final includeOffline = _asBool(context.vars['offline_support']);
  final isRestBackend = normalizedBackend == 'rest_firebase_hybrid';

  context.vars = {
    ...context.vars,
    'state_management': normalizedStateManagement,
    'backend': normalizedBackend,
    'auth': includeAuth,
    'offline_support': includeOffline,
    'include_auth': includeAuth,
    'include_offline': includeOffline,
    'is_riverpod': !isBloc,
    'is_bloc': isBloc,
    'is_rest_backend': isRestBackend,
    'is_firebase_backend': normalizedBackend == 'firebase',
    'uses_rest_cache': isRestBackend && (includeAuth || includeOffline),
    'uses_auth_refresh': isRestBackend && includeAuth,
    'uses_firebase_auth': isFirebaseBackend && includeAuth,
    'state_folder':
        normalizedStateManagement == 'bloc' ? 'controllers' : 'providers',
  };
}

bool _asBool(Object? value) {
  return switch (value) {
    bool value => value,
    String value => value.trim().toLowerCase() == 'true',
    _ => false,
  };
}
