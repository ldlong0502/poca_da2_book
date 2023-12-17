import 'package:intl/intl.dart';

class ConvertUtils {
  static String convertIntToDateTime(int time) {

    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    return DateFormat('dd/MM/yy HH:mm').format(dateTime);
  }

  static String convertIntToDateString(int time) {

    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    String formattedDate = "${dateTime.day}, ${getMonthName(dateTime.month)} ${dateTime.year}";
    return formattedDate;
  }

  static String convertIntToDuration(int seconds) {

    Duration duration = Duration(seconds: seconds);

    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);

    String formattedDuration = '';

    if (hours > 0) {
      formattedDuration += '$hours hr ';
    }

    if (minutes > 0) {
      formattedDuration += '$minutes min';
    }

    return formattedDuration.trim();
  }

  static String getMonthName(int month) {
    // Convert month number to month name
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }


  static String convertDob(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
}