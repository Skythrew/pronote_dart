import 'package:pronote_dart/src/models/grade.dart';
import 'package:pronote_dart/src/models/grade_value.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/subject_averages.dart';

class GradesOverview {
  final List<SubjectAverages> subjectAverages;
  final GradeValue? overallAverage;
  final GradeValue? classAverage;
  final List<Grade> grades;

  factory GradesOverview.fromJSON(Session session, Map<String, dynamic> json) {
    return GradesOverview(
        List<SubjectAverages>.from(json['listeServices']['V']
            .map((el) => SubjectAverages.fromJSON(el))
            .toList()),
        (json['moyGenerale'] != null)
            ? GradeValue.fromJSON(json['moyGenerale']['V'])
            : null,
        (json['moyGeneraleClasse'] != null)
            ? GradeValue.fromJSON(json['moyGeneraleClasse']['V'])
            : null,
        List<Grade>.from(json['listeDevoirs']['V']
            .map((grade) => Grade.fromJSON(session, grade))
            .toList()));
  }

  GradesOverview(this.subjectAverages, this.overallAverage, this.classAverage,
      this.grades);
}
