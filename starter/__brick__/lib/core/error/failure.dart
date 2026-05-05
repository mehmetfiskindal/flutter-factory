import 'app_exception.dart';

enum FailureType {
  network,
  unauthorized,
  cache,
  validation,
  unknown,
}

class Failure {
  const Failure({
    required this.message,
    required this.type,
    this.code,
    this.exception,
    this.stackTrace,
  });

  factory Failure.fromException(AppException exception) {
    return switch (exception) {
      UnauthorizedException() => Failure(
          message: exception.message,
          type: FailureType.unauthorized,
          code: exception.code,
          exception: exception,
          stackTrace: exception.stackTrace,
        ),
      NetworkException() => Failure(
          message: exception.message,
          type: FailureType.network,
          code: exception.code,
          exception: exception,
          stackTrace: exception.stackTrace,
        ),
      CacheException() => Failure(
          message: exception.message,
          type: FailureType.cache,
          code: exception.code,
          exception: exception,
          stackTrace: exception.stackTrace,
        ),
      ValidationException() => Failure(
          message: exception.message,
          type: FailureType.validation,
          code: exception.code,
          exception: exception,
          stackTrace: exception.stackTrace,
        ),
      UnknownAppException() => Failure(
          message: exception.message,
          type: FailureType.unknown,
          code: exception.code,
          exception: exception,
          stackTrace: exception.stackTrace,
        ),
    };
  }

  final String message;
  final FailureType type;
  final String? code;
  final AppException? exception;
  final StackTrace? stackTrace;

  bool get isUnauthorized => type == FailureType.unauthorized;

  bool get isNetwork => type == FailureType.network;

  @override
  String toString() {
    if (code == null) {
      return message;
    }

    return '[$code] $message';
  }
}
