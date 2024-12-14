import 'package:pronote_dart/src/models/assignment_return.dart';
import 'package:pronote_dart/src/models/assignment_theme.dart';
import 'package:pronote_dart/src/models/attachment.dart';
import 'package:pronote_dart/src/models/enums/assignment_difficulty.dart';
import 'package:pronote_dart/src/models/enums/assignment_return_kind.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/subject.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

class Assignment {
  final String id;
  final Subject subject;
  final String description;
  final String backgroundColor;
  final bool done;
  final DateTime deadline;
  final List<Attachment> attachments;
  final AssignmentDifficulty difficulty;

  /// Time it should take, in minutes, to do the homework.
  final double? length;

  /// Themes associated with this homework.
  final List<AssignmentTheme> themes;
  final AssignmentReturn assignmentReturn;

  /// If defined, can be used to retrieve the lesson contents from the resources tab.
  final String? resourceID;

  factory Assignment.fromJSON(Session session, Map<String, dynamic> json) {
    return Assignment(
        json['N'],
        Subject.fromJSON(json['Matiere']['V']),
        json['descriptif']['V'],
        json['CouleurFond'],
        json['TAFFait'],
        decodePronoteDate(json['PourLe']['V']),
        List<Attachment>.from(json['ListePieceJointe']['V']
            .map((el) => Attachment.fromJSON(session, el))),
        AssignmentDifficulty.fromInt(json['niveauDifficulte']),
        json['duree'],
        List<AssignmentTheme>.from(
            json['ListeThemes']['V'].map((el) => AssignmentTheme.fromJSON(el))),
        AssignmentReturn(
            (json['genreRendu'] != null)
                ? AssignmentReturnKind.fromInt(json['genreRendu'])
                : AssignmentReturnKind.none,
            (json['documentRendu'] != null)
                ? Attachment.fromJSON(session, json['documentRendu']['V'])
                : null,
            json['peuRendre'] ?? false),
        json['cahierDeTextes']?['V']['N']);
  }

  Assignment(
      this.id,
      this.subject,
      this.description,
      this.backgroundColor,
      this.done,
      this.deadline,
      this.attachments,
      this.difficulty,
      this.length,
      this.themes,
      this.assignmentReturn,
      this.resourceID);
}
