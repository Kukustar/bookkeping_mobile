import 'package:intl/intl.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isYesterday(DateTime other) {
    final yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);

    return other.year == yesterday.year && other.month == yesterday.month && other.day == yesterday.day;
  }
}

extension StartDay on DateTime {
  DateTime getStartDate() {
    return DateTime(year, month, day);
  }
}

extension EndDay on DateTime {
  DateTime getEndDate() {
    return DateTime(year, month, day, 23, 59, 59, 59, 59);
  }
}

extension ToHashMapKeyFormat on DateTime {
  String toHashMapKeyFormat() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
