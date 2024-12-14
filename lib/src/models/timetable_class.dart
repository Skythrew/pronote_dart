import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/timetable_class_activity.dart';
import 'package:pronote_dart/src/models/timetable_class_detention.dart';
import 'package:pronote_dart/src/models/timetable_class_lesson.dart';
import 'package:pronote_dart/src/utils/pronote_date_decoder.dart';
import 'package:pronote_dart/src/utils/timings.dart';
import 'package:pronote_dart/src/utils/week_number.dart';

class TimetableClass {
  final String id;
  final String? backgroundColor;
  final DateTime startDate;
  final DateTime endDate;
  final num blockLength;
  final num blockPosition;
  final String? notes;
  final num weekNumber;
  final dynamic data;

  factory TimetableClass.fromJSON(Session session, Map<String, dynamic> json) {
    isTimetableClassActivity(Map<String, dynamic> json) =>
        json['estSortiePedagogique'] != null && json['estSortiePedagogique'];
    isTimetableClassDetention(Map<String, dynamic> json) =>
        json['estRetenue'] != null;

    final startDate = decodePronoteDate(json['DateDuCours']['V']);
    final blockPosition = json['place'];
    final blockLength = json['duree'];
    DateTime endDate;

    if (json['DateDuCoursFin']?['V'] is String) {
      endDate = decodePronoteDate(json['DateDuCoursFin']['V']);
    } else {
      final position =
          blockPosition % session.instance.blocksPerDay + blockLength - 1;
      final timings = translatePositionToTimings(session, position);

      endDate =
          startDate.copyWith(hour: timings.hours, minute: timings.minutes);
    }

    late final dynamic classData;

    if (isTimetableClassActivity(json)) {
      classData = TimetableClassActivity.fromJSON(json);
    } else if (isTimetableClassDetention(json)) {
      classData = TimetableClassDetention.fromJSON(json);
    } else {
      classData = TimetableClassLesson.fromJSON(json);
    }

    return TimetableClass(
        json['N'],
        json['CouleurFond'],
        startDate,
        endDate,
        blockLength,
        blockPosition,
        json['memo'],
        translateToWeekNumber(startDate, session.instance.firstMonday),
        classData);
  }

  TimetableClass(
      this.id,
      this.backgroundColor,
      this.startDate,
      this.endDate,
      this.blockLength,
      this.blockPosition,
      this.notes,
      this.weekNumber,
      this.data);
}
