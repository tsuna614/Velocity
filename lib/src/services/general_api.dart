abstract class GeneralApi {
  static String getTime(DateTime time) {
    double secondPassed = DateTime.now().difference(time).inSeconds.toDouble();
    if (secondPassed < 60) {
      return "${secondPassed.toInt()}s";
    }
    double minutePassed = DateTime.now().difference(time).inMinutes.toDouble();
    if (minutePassed < 60) {
      return "${minutePassed.toInt()}m";
    }
    double hourPassed = DateTime.now().difference(time).inHours.toDouble();
    if (hourPassed < 24) {
      return "${hourPassed.toInt()}h";
    }
    double dayPassed = DateTime.now().difference(time).inDays.toDouble();
    if (dayPassed < 7) {
      return "${dayPassed.toInt()}d";
    } else {
      return "${(dayPassed / 7).toInt()}w";
    }
  }
}
