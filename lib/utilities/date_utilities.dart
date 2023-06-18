import 'package:intl/intl.dart';

final DateFormat dateShortFormatter = DateFormat('dd-MMM-yy');
final DateFormat dateFormatter = DateFormat('dd-MMM-yyyy');
final DateFormat dateLongFormatter = DateFormat('dd-MMM-yyyy (EEEE)');
final DateFormat dateMonthYearFormatter = DateFormat('MMM yyyy');
final DateFormat dateDayOfWeekFormatter = DateFormat('EEEE');
final DateFormat dateShortDayOfWeekFormatter = DateFormat('EEE');
final DateFormat dayFormatter = DateFormat('dd');
final DateFormat monthNameFormatter = DateFormat('MMM');
final DateFormat monthNumFormatter = DateFormat('MM');
final DateFormat yearLongFormatter = DateFormat('yyyy');
final DateFormat yearShortFormatter = DateFormat('yy');

extension FirstDateOfWeek on DateTime {
  DateTime getDateOfFirstDayOfWeek() {
    return DateTime(year, month, day).subtract(Duration(days: weekday - 1));
  }

  DateTime getDateOfLastDayOfWeek() {
    return DateTime(year, month, day)
        .add(Duration(days: DateTime.daysPerWeek - weekday));
  }
}
