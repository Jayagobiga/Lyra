import 'package:intl/intl.dart';

int calculateDayDifference(DateTime? selectedDate) {
  if (selectedDate != null) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selectedDay.isAfter(yesterday) || selectedDay.isAtSameMomentAs(yesterday)) {
      return 1;
    } else {
      int differenceInDays = today.difference(selectedDay).inDays;
      return differenceInDays + 1;
    }
  } else {
    return 0;
  }
}
