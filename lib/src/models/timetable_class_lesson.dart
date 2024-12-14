import 'package:pronote_dart/src/models/subject.dart';

class TimetableClassLesson {
  final num kind;

  final String? status;

  /// Whether the lesson has been canceled or not.
  final bool canceled;

  /// Whether the user is exempted from this lesson or not.
  final bool exempted;

  /// Whether there will be a test in the lesson or not.
  final bool test;

  /// List of URLs for virtual classrooms.
  final List<String> virtualClassrooms;

  /// List of personal names.
  final List<String> personalNames;

  /// List of teachers' names.
  final List<String> teacherNames;

  /// List of classrooms.
  final List<String> classrooms;

  /// List of group names.
  final List<String> groupNames;

  /// Subject of the lesson.
  final Subject? subject;

  /// Returns `null` when there's no resource attached to the lesson.
  /// Otherwise, returns an ID which can be used in `lessonResource` method.
  final String? lessonResourceID;

  factory TimetableClassLesson.fromJSON(Map<String, dynamic> json) {
    final List<String> virtualClassrooms = [];
    final List<String> teacherNames = [];
    final List<String> personalNames = [];
    final List<String> classrooms = [];
    final List<String> groupNames = [];

    Subject? subject;
    String? lessonResourceID;

    if (json['listeVisios'] != null) {
      for (final virtualClassroomJSON in json['listeVisios']['V']) {
        virtualClassrooms.add(virtualClassroomJSON['url']);
      }
    }

    if (json['ListeContenus'] != null) {
      for (final data in json['ListeContenus']['V']) {
        switch (data['G']) {
          case 16:
            subject = Subject.fromJSON(data);
            break;
          case 3:
            teacherNames.add(data['L']);
            break;
          case 34:
            personalNames.add(data['L']);
            break;
          case 17:
            classrooms.add(data['L']);
            break;
          case 2:
            groupNames.add(data['L']);
            break;
        }
      }
    }

    if (json['AvecCdT'] != null &&
        json['AvecCdT'] &&
        json['cahierDeTextes'] != null) {
      lessonResourceID = json['cahierDeTextes']['V']['N'];
    }

    return TimetableClassLesson(
        json['G'],
        json['Statut'],
        json['estAnnule'] ?? false,
        json['dispenseEleve'] ?? false,
        json['cahierDeTextes']?['V']['estDevoir'] ?? false,
        virtualClassrooms,
        personalNames,
        teacherNames,
        classrooms,
        groupNames,
        subject,
        lessonResourceID);
  }

  TimetableClassLesson(
      this.kind,
      this.status,
      this.canceled,
      this.exempted,
      this.test,
      this.virtualClassrooms,
      this.personalNames,
      this.teacherNames,
      this.classrooms,
      this.groupNames,
      this.subject,
      this.lessonResourceID);
}
