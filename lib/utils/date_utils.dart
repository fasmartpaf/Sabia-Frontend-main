import 'package:intl/intl.dart';

int calculateDateDifferenceFromToday(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

int calculateDateDifferenceFromTodayInMinutes(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(
          date.year, date.month, date.day, date.hour, date.minute, date.second)
      .difference(DateTime(
          now.year, now.month, now.day, now.hour, now.minute, now.second))
      .inMinutes;
}

bool dateIsToday(DateTime date) => calculateDateDifferenceFromToday(date) == 0;
bool dateIsYesterday(DateTime date) =>
    calculateDateDifferenceFromToday(date) == -1;

String formattedDateFromDateTime(DateTime date) {
  final DateFormat formatter = DateFormat("dd/MM/yyyy");
  return formatter.format(date);
}

DateTime dateTimeFromFirebaseTimestamp(int firebaseTimestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(firebaseTimestamp * 1000);
}

String formattedDayAndHourFromFirebaseTimestamp(
  int firebaseTimestamp, {
  String format,
}) {
  final date = dateTimeFromFirebaseTimestamp(firebaseTimestamp);

  final differenceInMinutesToNow =
      calculateDateDifferenceFromTodayInMinutes(date).abs();

  if (differenceInMinutesToNow <= 60) {
    return "à $differenceInMinutesToNow minutos";
  }

  if (dateIsToday(date)) {
    final DateFormat formatter = DateFormat("HH:mm");
    return "Hoje às ${formatter.format(date)}h";
  }
  if (dateIsYesterday(date)) {
    final DateFormat formatter = DateFormat("HH:mm");
    return "Ontem ${formatter.format(date)}h";
  }

  final DateFormat formatter =
      DateFormat(format != null ? format : "dd/MM/yy 'às' HH:mm'h'");
  return formatter.format(date);
}
