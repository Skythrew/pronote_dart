import 'package:pronote_dart/src/models/subject.dart';

class AssignmentTheme {
  final String id;
  final String name;
  final Subject subject;

  factory AssignmentTheme.fromJSON(Map<String, dynamic> json) {
    return AssignmentTheme(
        json['N'], json['L'], Subject.fromJSON(json['Matiere']['V']));
  }

  AssignmentTheme(this.id, this.name, this.subject);
}
