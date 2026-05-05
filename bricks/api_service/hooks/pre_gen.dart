import 'package:mason/mason.dart';

void run(HookContext context) {
  final name = context.vars['name'] as String? ?? 'resource';
  final endpoint = (context.vars['endpoint'] as String?)?.trim();

  context.vars = {
    ...context.vars,
    'endpoint': endpoint == null || endpoint.isEmpty
        ? '/${_toParamCase(name)}'
        : _normalizeEndpoint(endpoint),
  };
}

String _normalizeEndpoint(String endpoint) {
  return endpoint.startsWith('/') ? endpoint : '/$endpoint';
}

String _toParamCase(String value) {
  return value
      .replaceAllMapped(
        RegExp('([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)}-${match.group(2)}',
      )
      .replaceAll(RegExp(r'[\s_]+'), '-')
      .replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '')
      .toLowerCase();
}
