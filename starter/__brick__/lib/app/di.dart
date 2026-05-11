{{#is_riverpod}}{{#uses_rest_cache}}import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
{{/uses_rest_cache}}import 'package:flutter_riverpod/flutter_riverpod.dart';

{{#uses_rest_cache}}import '../core/cache/cache_providers.dart';
{{/uses_rest_cache}}{{#include_offline}}import '../core/offline/offline_providers.dart';
import '../core/offline/offline_service.dart';
{{/include_offline}}{{#include_auth}}import '../features/auth/presentation/providers/auth_controller.dart';
{{/include_auth}}import 'flavor.dart';

Future<ProviderContainer> configureDependencies(
  AppEnvironment environment,
) async {
  {{#uses_rest_cache}}final documentsDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);

  final appCacheBox = await Hive.openBox<dynamic>('app_cache');
  final secureCacheBox = await Hive.openBox<dynamic>('secure_cache');

  {{/uses_rest_cache}}final container = ProviderContainer(
    overrides: [
      appEnvironmentProvider.overrideWithValue(environment),
      {{#uses_rest_cache}}appCacheBoxProvider.overrideWithValue(appCacheBox),
      secureCacheBoxProvider.overrideWithValue(secureCacheBox),
      {{/uses_rest_cache}}{{#include_offline}}connectivityServiceProvider.overrideWithValue(
        ConnectivityService(),
      ),
      {{/include_offline}}
    ],
  );

  {{#include_auth}}await container.read(authControllerProvider.future);

  {{/include_auth}}return container;
}
{{/is_riverpod}}{{#is_bloc}}{{#is_rest_backend}}import 'package:dio/dio.dart';
{{#uses_rest_cache}}import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
{{/uses_rest_cache}}import 'package:logger/logger.dart';

{{#uses_rest_cache}}import '../core/cache/cache_store.dart';
{{/uses_rest_cache}}import '../core/logging/app_logger.dart';
{{#include_auth}}import '../core/network/api_interceptor.dart';
import '../core/network/token_storage.dart';
{{/include_auth}}{{#include_offline}}import '../core/offline/offline_service.dart';
{{/include_offline}}import '../core/utils/constants/network_constants.dart';
{{#include_auth}}import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/datasources/auth_token_refresher.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/get_current_user.dart';
import '../features/auth/domain/usecases/sign_in.dart';
import '../features/auth/domain/usecases/sign_out.dart';
{{/include_auth}}import 'flavor.dart';

class AppDependencies {
  const AppDependencies({
    required this.environment,
    {{#uses_rest_cache}}required this.appCacheStore,
    required this.secureCacheStore,
    {{/uses_rest_cache}}required this.logger,
    required this.dio,
    {{#include_auth}}required this.tokenStorage,
    required this.authRepository,
    required this.getCurrentUserUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    {{/include_auth}}{{#include_offline}}required this.connectivityService,
    {{/include_offline}}
  });

  final AppEnvironment environment;
  {{#uses_rest_cache}}final CacheStore appCacheStore;
  final CacheStore secureCacheStore;
  {{/uses_rest_cache}}final Logger logger;
  final Dio dio;
  {{#include_auth}}final TokenStorage tokenStorage;
  final AuthRepository authRepository;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  {{/include_auth}}{{#include_offline}}final ConnectivityService connectivityService;
  {{/include_offline}}
}

Future<AppDependencies> configureDependencies(
  AppEnvironment environment,
) async {
  {{#uses_rest_cache}}final documentsDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);

  final appCacheBox = await Hive.openBox<dynamic>('app_cache');
  final secureCacheBox = await Hive.openBox<dynamic>('secure_cache');
  final appCacheStore = HiveCacheStore(appCacheBox);
  final secureCacheStore = HiveCacheStore(secureCacheBox);
  {{/uses_rest_cache}}{{#include_auth}}final tokenStorage = HiveTokenStorage(secureCacheStore);
  {{/include_auth}}final logger = createAppLogger(environment);
  final rawDio = _createRawDio(environment);
  {{#include_auth}}final tokenRefresher = AuthTokenRefresherImpl(
    client: rawDio,
    tokenStorage: tokenStorage,
  );
  {{/include_auth}}final dio = _createDio(
    environment: environment,
    logger: logger,
    rawDio: rawDio,
    {{#include_auth}}tokenStorage: tokenStorage,
    tokenRefresher: tokenRefresher,
    {{/include_auth}}
  );
  {{#include_auth}}final remoteDataSource = AuthRemoteDataSourceImpl(dio);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    tokenStorage: tokenStorage,
  );

  {{/include_auth}}return AppDependencies(
    environment: environment,
    {{#uses_rest_cache}}appCacheStore: appCacheStore,
    secureCacheStore: secureCacheStore,
    {{/uses_rest_cache}}logger: logger,
    dio: dio,
    {{#include_auth}}tokenStorage: tokenStorage,
    authRepository: authRepository,
    getCurrentUserUseCase: GetCurrentUserUseCase(authRepository),
    signInUseCase: SignInUseCase(authRepository),
    signOutUseCase: SignOutUseCase(authRepository),
    {{/include_auth}}{{#include_offline}}connectivityService: ConnectivityService(),
    {{/include_offline}}
  );
}

Dio _createRawDio(AppEnvironment environment) {
  return Dio(
    BaseOptions(
      baseUrl: environment.apiBaseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      sendTimeout: NetworkConstants.sendTimeout,
      headers: const {
        NetworkConstants.acceptHeader: NetworkConstants.applicationJson,
        NetworkConstants.contentTypeHeader: NetworkConstants.applicationJson,
      },
    ),
  );
}

Dio _createDio({
  required AppEnvironment environment,
  required Logger logger,
  required Dio rawDio,
  {{#include_auth}}required TokenStorage tokenStorage,
  required AuthTokenRefresher tokenRefresher,
  {{/include_auth}}
}) {
  rawDio.interceptors.clear();
  {{#include_auth}}rawDio.interceptors.add(
    ApiInterceptor(
      dio: rawDio,
      tokenStorage: tokenStorage,
      tokenRefresher: tokenRefresher,
      logger: logger,
      enableLogging: environment.enableNetworkLogs,
    ),
  );

  {{/include_auth}}return rawDio;
}
{{/is_rest_backend}}{{#is_firebase_backend}}import 'package:cloud_firestore/cloud_firestore.dart';
{{#include_auth}}import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
{{/include_auth}}import 'package:firebase_storage/firebase_storage.dart';

import '../core/firebase/cloud_storage_service.dart';
import '../core/firebase/firestore_service.dart';
{{#include_auth}}import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/create_account.dart';
import '../features/auth/domain/usecases/get_current_user.dart';
import '../features/auth/domain/usecases/send_password_reset_email.dart';
import '../features/auth/domain/usecases/sign_in.dart';
import '../features/auth/domain/usecases/sign_out.dart';
import '../features/auth/domain/usecases/watch_auth_state_changes.dart';
{{/include_auth}}import 'flavor.dart';

class AppDependencies {
  const AppDependencies({
    required this.environment,
    {{#include_auth}}required this.firebaseAuth,
    {{/include_auth}}required this.firestore,
    required this.storage,
    required this.firestoreService,
    required this.cloudStorageService,
    {{#include_auth}}required this.authRepository,
    required this.createAccountUseCase,
    required this.getCurrentUserUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.watchAuthStateChangesUseCase,
    {{/include_auth}}
  });

  final AppEnvironment environment;
  {{#include_auth}}final firebase_auth.FirebaseAuth firebaseAuth;
  {{/include_auth}}final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirestoreService firestoreService;
  final CloudStorageService cloudStorageService;
  {{#include_auth}}final AuthRepository authRepository;
  final CreateAccountUseCase createAccountUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final WatchAuthStateChangesUseCase watchAuthStateChangesUseCase;
  {{/include_auth}}
}

Future<AppDependencies> configureDependencies(
  AppEnvironment environment,
) async {
  {{#include_auth}}final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  {{/include_auth}}final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final firestoreService = FirestoreService(firestore);
  final cloudStorageService = CloudStorageService(storage);
  {{#include_auth}}final authRepository = AuthRepositoryImpl(firebaseAuth: firebaseAuth);

  {{/include_auth}}return AppDependencies(
    environment: environment,
    {{#include_auth}}firebaseAuth: firebaseAuth,
    {{/include_auth}}firestore: firestore,
    storage: storage,
    firestoreService: firestoreService,
    cloudStorageService: cloudStorageService,
    {{#include_auth}}authRepository: authRepository,
    createAccountUseCase: CreateAccountUseCase(authRepository),
    getCurrentUserUseCase: GetCurrentUserUseCase(authRepository),
    sendPasswordResetEmailUseCase:
        SendPasswordResetEmailUseCase(authRepository),
    signInUseCase: SignInUseCase(authRepository),
    signOutUseCase: SignOutUseCase(authRepository),
    watchAuthStateChangesUseCase: WatchAuthStateChangesUseCase(authRepository),
    {{/include_auth}}
  );
}
{{/is_firebase_backend}}{{/is_bloc}}
