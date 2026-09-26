class Helpers {
  static String formatForecastTime(DateTime time) {
    int hour = time.hour;

    final String period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    return '$hour:00 $period';
  }
}