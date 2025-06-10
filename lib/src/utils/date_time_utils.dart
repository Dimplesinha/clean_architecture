import 'package:intl/intl.dart';
import 'package:workapp/src/core/constants/date_time_constants.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03-10-2024
/// @Message : [DateTimeUtils]

class DateTimeUtils {
  static final DateTimeUtils _singleton = DateTimeUtils._internal();

  DateTimeUtils._internal();

  static DateTimeUtils get instance => _singleton;

  dynamic stringToDateInLocal({required String string}) {
    if (string.isNotEmpty) {
      var convertedDate = DateTime.parse(string);

      DateTime utcDateTime = DateTime.utc(
          convertedDate.year,
          convertedDate.month,
          convertedDate.day,
          convertedDate.hour,
          convertedDate.minute,
          convertedDate.second,
          convertedDate.millisecond); // Example UTC DateTime

      // Convert to local time zone
      return utcDateTime.toLocal();
    }
    return '-';
  }

  String timeDifference({DateTime? value}) {
    if (value == null) return '';

    final localDate = value.toLocal();
    final currentLocalTime = DateTime.now().toLocal();
    final duration = currentLocalTime.difference(localDate);

    // Calculate years, months, and days
    final years = (duration.inDays / 365).floor();
    final remainingDaysAfterYears = duration.inDays - (years * 365);
    final months = (remainingDaysAfterYears / 30).floor();
    final days = remainingDaysAfterYears - (months * 30);

    List<String> result = [];

    if (years > 0) result.add('${years}Y');
    if (months > 0) result.add('${months}M');
    if (days > 0) result.add('${days}D');

    return result.isNotEmpty ? result.join(', ') : '-';
  }

  String timeStampToDateOnly(DateTime? time) {
    if (time == null) {
      return '';
    }
    final DateTime loadedDate = time;

    return DateFormat(DateTimeConstants.dateFormatYYYYMMDD).format(loadedDate);
  }

  String timeStampToDate(DateTime? time) {
    if (time == null) {
      return '';
    }
    final DateTime loadedDate = time;

    return DateFormat(DateTimeConstants.dateFormatDDMMYYYYWithSlash).format(loadedDate);
  }

  String timeStampToDateTime(DateTime? time) {
    if (time == null) {
      return '';
    }
    final DateTime loadedDate = time;

    return DateFormat(DateTimeConstants.dateFormatDDMMYYYYHhMm).format(loadedDate);
  }

  String dateOnlyWithSlash(DateTime? time) {
    if (time == null) {
      return '';
    }
    final DateTime loadedDate = time;
    return DateFormat(DateTimeConstants.dateFormatDDMMYYYYWithSlash).format(loadedDate);
  }

  static String subscriptionDate(String time) {
    // Parse the input time string to DateTime object
    if (time.isNotEmpty && time != '') {
      try {
        DateTime dt = DateTime.parse(time);
        // Convert the parsed time to UTC and then to the local timezone
        DateTime utcDateTime = DateTime.utc(
          dt.year,
          dt.month,
          dt.day,
          dt.hour,
          dt.minute,
          dt.second,
          dt.millisecond,
        ).toLocal();

        // Format the date as "MMM-dd-yyyy hh:mm a" (e.g., Jan-18-2024 06:43 pm)
        String formattedDate = DateFormat('dd MMM yyyy ').format(utcDateTime);

        return formattedDate;
      } catch (e) {
        // Return the original date if parsing fails
        return time;
      }
    }
    return time;
  }
}
