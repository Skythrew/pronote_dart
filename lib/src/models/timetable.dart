import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/timetable_class.dart';

class Timetable {
  final List<TimetableClass> classes;
  final dynamic absences; // TODO
  final bool withCanceledClasses;

  factory Timetable.fromJSON(Session session, Map<String, dynamic> json) {
    final timetableClasses = List<TimetableClass>.from(
        (json['ListeCours'] ?? [])
            .map((el) => TimetableClass.fromJSON(session, el))
            .toList());

    timetableClasses.sort((a, b) =>
        a.startDate.millisecondsSinceEpoch -
        b.startDate.millisecondsSinceEpoch);

    return Timetable(
        timetableClasses, json['absences'], json['avecCoursAnnule'] ?? true);
  }

  Timetable(this.classes, this.absences, this.withCanceledClasses);
}
