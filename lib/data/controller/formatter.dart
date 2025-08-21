import 'package:intl/intl.dart';

class Formatter {
  String formatDate(dynamic data) {

    DateTime createdAt = data['createdAt'].toDate();
    String monthYear = DateFormat('MMMM yyyy').format(createdAt);
    return monthYear;
  }
}
