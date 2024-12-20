import 'package:pronote_dart/src/models/errors/unreachable_error.dart';

final shortDateRegex = RegExp(r'^\d{2}\/\d{2}\/\d{4}$');
final longDateLongHoursRegex =
    RegExp(r'^\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}:\d{2}$');
final longDateShortHoursRegex = RegExp(r'^\d{2}\/\d{2}\/\d{2} \d{2}h\d{2}$');
final yearFirstTwoChars = DateTime.now().year.toString().substring(0, 2);

DateTime decodePronoteDate(String formatted) {
  if (shortDateRegex.hasMatch(formatted)) {
    final [day, month, year] = formatted.split('/').map((el) {
      return int.parse(el);
    }).toList();
    return DateTime(year, month, day);
  } else if (longDateLongHoursRegex.hasMatch(formatted)) {
    final [date, time] = formatted.split(' ');
    final [day, month, year] = date.split('/').map((el) {
      return int.parse(el);
    }).toList();
    final [hours, minutes, seconds] = time.split(':').map((el) {
      return int.parse(el);
    }).toList();

    final output = DateTime(year, month, day, hours, minutes, seconds);
    return output;
  } else if (longDateShortHoursRegex.hasMatch(formatted)) {
    final [date, time] = formatted.split(' ');
    final [day, month, year] = date.split('/').map((el) {
      return int.parse(el);
    }).toList();
    final [hours, minutes] = time.split('h').map((el) {
      return int.parse(el);
    }).toList();

    final output = DateTime(
        int.parse('$yearFirstTwoChars$year'), month, day, hours, minutes);
    return output;
  }

  throw UnreachableError();
}

String encodePronoteDate(DateTime date) {
  final day = date.day;
  final month = date.month;
  final year = date.year;

  final hours = date.hour;
  final minutes = date.minute;
  final seconds = date.second;

  return '$day/$month/$year $hours:$minutes:$seconds';
}
