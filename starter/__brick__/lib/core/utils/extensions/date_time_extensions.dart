extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String toShortDate() {
    final dayValue = day.toString().padLeft(2, '0');
    final monthValue = month.toString().padLeft(2, '0');
    return '$dayValue/$monthValue/$year';
  }

  String toIsoDate() {
    final monthValue = month.toString().padLeft(2, '0');
    final dayValue = day.toString().padLeft(2, '0');
    return '$year-$monthValue-$dayValue';
  }
}
