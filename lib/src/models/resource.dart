import 'package:pronote_dart/src/models/resource_content.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/subject.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

class Resource {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final Subject subject;

  final bool hasAssignment;
  final DateTime? assignmentDeadline;

  /// Color of the resource (in HEX).
  final String backgroundColor;
  final List<ResourceContent> contents;
  final List<String> teachers;
  final List<String> groups;

  factory Resource.fromJSON(Session session, Map<String, dynamic> json) {
    return Resource(
      id: json['N'],
      startDate: decodePronoteDate(json['Date']['V']),
      endDate: decodePronoteDate(json['DateFin']['V']),
      subject: Subject.fromJSON(json['Matiere']['V']),
      hasAssignment: json['dateTAF'] != null,
      assignmentDeadline: (json['dateTAF']?['V'] != null) ? decodePronoteDate(json['dateTAF']['V']) : null,
      backgroundColor: json['CouleurFond'],
      contents: List<ResourceContent>.from(json['listeContenus']['V'].map((el) => ResourceContent.fromJSON(session, el))),
      teachers: List<String>.from(json['listeProfesseurs']['V'].map((el) => el['L'])),
      groups: List<String>.from(json['listeGroupes']['V'].map((el) => el['L']))
    );
  }

  Resource({required this.id, required this.startDate, required this.endDate, required this.subject, required this.hasAssignment, required this.assignmentDeadline, required this.backgroundColor, required this.contents, required this.teachers, required this.groups});
}