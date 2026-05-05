abstract final class Validators {
  static String? requiredField(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }

    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, label: 'Email');
    if (requiredError != null) {
      return requiredError;
    }

    final isValid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!);
    if (!isValid) {
      return 'Enter a valid email.';
    }

    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    final requiredError = requiredField(value, label: 'Password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length < minLength) {
      return 'Use at least $minLength characters.';
    }

    return null;
  }
}
