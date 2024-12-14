import 'package:pronote_dart/src/models/grade_value.dart';
import 'package:pronote_dart/src/models/subject.dart';

class SubjectAverages {
  /// Student's average in the subject.
  final GradeValue? student;

  /// Class's average in the subject.
  final GradeValue classAverage;

  /// Highest average in the class.
  final GradeValue max;

  /// Lowest average in the class.
  final GradeValue min;

  /// Maximum amount of points.
  final GradeValue? outOf;

  /// The default maximum amount of points.
  final GradeValue? defaultOutOf;

  /// Subject the average is from.
  final Subject subject;

  /// Background color of the subject.
  final String backgroundColor;

  factory SubjectAverages.fromJSON(Map<String, dynamic> json) {
    return SubjectAverages(
        (json['moyEleve'] != null)
            ? GradeValue.fromJSON(json['moyEleve']['V'])
            : null,
        GradeValue.fromJSON(json['moyClasse']['V']),
        GradeValue.fromJSON(json['moyMax']['V']),
        GradeValue.fromJSON(json['moyMin']['V']),
        (json['baremeMoyEleve'] != null)
            ? GradeValue.fromJSON(json['baremeMoyEleve']['V'])
            : null,
        (json['baremeMoyEleveParDefaut'] != null)
            ? GradeValue.fromJSON(json['baremeMoyEleveParDefaut']['V'])
            : null,
        Subject.fromJSON(json),
        json['couleur']);
  }

  SubjectAverages(this.student, this.classAverage, this.max, this.min,
      this.outOf, this.defaultOutOf, this.subject, this.backgroundColor);
}
