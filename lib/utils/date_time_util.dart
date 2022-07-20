import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meta/meta.dart';
import 'package:time/time.dart';

extension DateTimeExtension on DateTime {
  String display({
    String format = "dd/MM/y",
  }) {
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(this);
  }

  DateTime addDays(int days) => this + days.days;
  DateTime subtractDays(int days) => this - days.days;
}

class DateTimeUtil {
  static final DateTimeUtil _instance = DateTimeUtil._internal();

  factory DateTimeUtil() {
    return _instance;
  }

  DateTimeUtil._internal() {
    initializeDateFormatting("pt_BR", null);
  }

  String dateStringFromMillisecondsTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    DateFormat dateFormat = DateFormat("dd/MM/y");
    return dateFormat.format(dateTime);
  }

  int getTodayTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  int daysAheadSinceTodayTimestamp({@required int daysToAdd}) {
    return DateTime.now().add(Duration(days: daysToAdd)).millisecondsSinceEpoch;
  }

  int daysAheadSinceDateTimestamp({
    @required int sinceDate,
    @required int daysToAdd,
  }) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(sinceDate);
    return dateTime.add(Duration(days: daysToAdd)).millisecondsSinceEpoch;
  }

  int dateDistance({
    @required int firstDateTimestamp,
    @required int secondDateTimestamp,
  }) {
    DateTime firstDate =
        DateTime.fromMillisecondsSinceEpoch(firstDateTimestamp);
    DateTime secondDate =
        DateTime.fromMillisecondsSinceEpoch(secondDateTimestamp);

    Duration difference = firstDate.difference(secondDate);
    return difference.inDays;
  }
}
