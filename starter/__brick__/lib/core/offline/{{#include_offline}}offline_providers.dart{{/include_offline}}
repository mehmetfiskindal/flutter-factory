{{#is_riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'offline_service.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final offlineStatusProvider = StreamProvider<OfflineStatus>((ref) {
  return ref.watch(connectivityServiceProvider).watchStatus();
});
{{/is_riverpod}}{{#is_bloc}}export 'offline_service.dart';
{{/is_bloc}}
