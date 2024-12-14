import 'package:pronote_dart/src/models/attachment.dart';
import 'package:pronote_dart/src/models/enums/attachment_kind.dart';
import 'package:pronote_dart/src/models/grade_value.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/subject.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

class Grade {
  /// The id of the grade.
  final String id;

  /// The actual grade.
  final GradeValue value;

  /// The maximum amount of points.
  final GradeValue outOf;

  /// The default maximum amount of points.
  final GradeValue? defaultOutOf;

  /// The date on which the grade was given.
  final DateTime date;

  /// The subject in which the grade was given.
  final Subject subject;

  /// The class average
  final GradeValue? average;

  /// The highest grade.
  final GradeValue max;

  /// The lowest grade.
  final GradeValue min;

  /// The coefficient of the grade.
  final num coefficient;

  /// Comment on the grade description.
  final String comment;

  /// Note on the grade.
  final String? noteComment;

  /// Whether the grade is bonus or not : only points above 10 count.
  final bool isBonus;

  /// Whether the grade is optional or not : the grade only counts if it increases the average.
  final bool isOptional;

  /// Whether the grade is out of 20 or not. Example 5/10 => 10/20
  final bool isOutOf20;

  /// The file of the subject.
  final Attachment? subjectFile;

  /// The file of the correction.
  final Attachment? correctionFile;

  factory Grade.fromJSON(Session session, Map<String, dynamic> json) {
    final id = json['N'];
    final isBonus = json['estBonus'];

    attachment(String key, String genre) {
      if (json[key] == null) {
        return null;
      }

      return Attachment.fromJSON(
          session, {'G': AttachmentKind.file.code, 'L': json[key], 'N': id});
    }

    return Grade(
        id,
        GradeValue.fromJSON(json['note']['V']),
        GradeValue.fromJSON(json['bareme']['V']),
        GradeValue.fromJSON(json['baremeParDefaut']['V']),
        decodePronoteDate(json['date']['V']),
        Subject.fromJSON(json['service']['V']),
        (json['moyenne'] != null)
            ? GradeValue.fromJSON(json['moyenne']['V'])
            : null,
        GradeValue.fromJSON(json['noteMax']['V']),
        GradeValue.fromJSON(json['noteMin']['V']),
        json['coefficient'],
        json['commentaire'],
        json['commentaireSurNote'],
        isBonus,
        json['estFacultatif'] && !isBonus,
        json['estRamenerSur20'],
        attachment('libelleSujet', 'DevoirSujet'),
        attachment('libelleCorrige', 'DevoirCorrige'));
  }

  Grade(
      this.id,
      this.value,
      this.outOf,
      this.defaultOutOf,
      this.date,
      this.subject,
      this.average,
      this.max,
      this.min,
      this.coefficient,
      this.comment,
      this.noteComment,
      this.isBonus,
      this.isOptional,
      this.isOutOf20,
      this.subjectFile,
      this.correctionFile);
}
