import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(Duration(days: 1));

  String day;

  if (date.isAfter(today)) {
    day = "Today";
  } else if (date.isAfter(yesterday)) {
    day = "Yesterday";
  } else {
    day = DateFormat('yyyy-MM-dd')
        .format(date); // Customize the date format if needed
  }

  String time = DateFormat('HH:mm').format(date); // Time in hours and minutes

  return '$day, $time';
}
