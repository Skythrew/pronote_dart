import 'package:pronote_dart/src/models/enums/notebook_observation_kind.dart';
import 'package:pronote_dart/src/models/subject.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

class NotebookObservation {
  final String id;
  final DateTime date;

  final bool opened;
  final bool shouldParentsJustify;

  final String name;
  final NotebookObservationKind kind;

  /// ID of the observation section.
  final String sectionID;

  final Subject? subject;
  final String? reason;

  factory NotebookObservation.fromJSON(Map<String, dynamic> json) {
    Subject? subject;

    if (json['matiere']['V']['L'] != null && json['matiere']['V']['N'] != '0') {
      subject = Subject.fromJSON(json['matiere']['V']);
    }

    return NotebookObservation(
      id: json['N'],
      date: decodePronoteDate(json['date']['V']),
      opened: json['estLue'],
      shouldParentsJustify: json['avecARObservation'],
      name: json['L'],
      kind: NotebookObservationKind.fromInt(json['genreObservation']),
      sectionID: json['rubrique']['V']['N'],
      subject: subject,
      reason: json['commentaire']
    );
  }

  NotebookObservation({required this.id, required this.date, required this.opened, required this.shouldParentsJustify, required this.name, required this.kind, required this.sectionID, required this.subject, required this.reason});
}