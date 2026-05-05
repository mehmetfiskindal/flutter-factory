import 'app_exception.dart';
import 'error_handler.dart';

abstract final class ExceptionMapper {
  static AppException map(Object error) {
    return ErrorHandler.toException(error);
  }
}
