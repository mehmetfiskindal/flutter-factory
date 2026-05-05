import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../core/cache/cache_providers.dart';
import '../features/auth/presentation/providers/auth_controller.dart';
import 'flavor.dart';

Future<ProviderContainer> configureDependencies(
  AppEnvironment environment,
) async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);

  final appCacheBox = await Hive.openBox<dynamic>('app_cache');
  final secureCacheBox = await Hive.openBox<dynamic>('secure_cache');

  final container = ProviderContainer(
    overrides: [
      appEnvironmentProvider.overrideWithValue(environment),
      appCacheBoxProvider.overrideWithValue(appCacheBox),
      secureCacheBoxProvider.overrideWithValue(secureCacheBox),
    ],
  );

  await container.read(authControllerProvider.future);

  return container;
}
