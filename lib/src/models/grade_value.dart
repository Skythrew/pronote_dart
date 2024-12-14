import 'package:pronote_dart/src/models/enums/grade_kind.dart';
import 'package:pronote_dart/src/models/errors/unreachable_error.dart';

class GradeValue {
  final GradeKind kind;
  final num? points;

  factory GradeValue.fromJSON(dynamic grade) {
    GradeKind kind = GradeKind.grade;
    num? value;

    if (grade is String) {
      if (grade.split('|').length >= 2) {
        kind = GradeKind.fromInt(int.parse(grade.split('|')[1]));
      }

      value = num.tryParse(grade.replaceAll(',', '.'));

      if (kind == GradeKind.absentZero || kind == GradeKind.unreturnedZero) {
        value = 0.00;
      }
    } else if (grade is num) {
      value = grade;
    } else {
      throw UnreachableError();
    }

    return GradeValue(kind, value);
  }

  GradeValue(this.kind, this.points);
}
