sealed class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() {
    if (code == null) {
      return message;
    }

    return '[$code] $message';
  }
}

final class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
    this.statusCode,
  });

  final int? statusCode;
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Your session has expired. Please sign in again.',
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class UnknownAppException extends AppException {
  const UnknownAppException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}
