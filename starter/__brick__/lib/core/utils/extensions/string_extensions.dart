extension StringExtensions on String {
  String get capitalized {
    if (isEmpty) {
      return this;
    }

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get titleCased {
    return trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word.capitalized)
        .join(' ');
  }

  bool get isValidEmail {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(this);
  }

  String nullIfBlank() {
    final value = trim();
    return value.isEmpty ? '' : value;
  }
}
