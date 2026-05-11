{{#is_rest_backend}}import 'dart:convert';

import '../../../../core/network/token_storage.dart';
import '../../../../core/utils/constants/cache_keys.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<AuthUser?> currentUser() async {
    final accessToken = _tokenStorage.readAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    return _tokenStorage.readUser();
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.signIn(
      email: email,
      password: password,
    );

    await _tokenStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    await _tokenStorage.saveUser(session.user);

    return session.user;
  }

  @override
  Future<void> signOut() {
    return _tokenStorage.clearTokens();
  }
}

extension on TokenStorage {
  AuthUser? readUser() {
    final cachedUser = readValue(CacheKeys.user);
    if (cachedUser == null || cachedUser.isEmpty) {
      return null;
    }

    final json = jsonDecode(cachedUser) as Map<String, dynamic>;
    return AuthUserModel.fromJson(json);
  }

  Future<void> saveUser(AuthUserModel user) {
    return writeValue(CacheKeys.user, jsonEncode(user.toJson()));
  }
}
{{/is_rest_backend}}{{#is_firebase_backend}}import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Future<AuthUser?> currentUser() async {
    return _firebaseAuth.currentUser?.toDomain();
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) => user?.toDomain());
  }

  @override
  Future<AuthUser> createAccount({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase Auth did not return a user.');
    }

    return user.toDomain();
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase Auth did not return a user.');
    }

    return user.toDomain();
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}

extension on firebase_auth.User {
  AuthUser toDomain() {
    return AuthUser(
      id: uid,
      email: email ?? '',
      displayName: displayName,
    );
  }
}
{{/is_firebase_backend}}
