import 'package:pronote_dart/src/models/attachment.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

class NotebookPunishment {
  final String id;

  final String title;

  final List<String> reasons;

  final bool isDuringLesson;
  final bool exclusion;

  final String workToDo;
  final List<Attachment> workToDoDocuments;

  final String circumstances;
  final List<Attachment> circumstancesDocuments;

  final String giver;
  final DateTime dateGiven;

  final int durationMinutes;

  factory NotebookPunishment.fromJSON(Session session, Map<String, dynamic> json) {
    return NotebookPunishment(
      id: json['N'],
      title: json['nature']['V']['L'],
      reasons: List<String>.from(json['listeMotifs']['V'].map((el) => el['L'])),
      isDuringLesson: !json['horsCours'],
      exclusion: json['estUneExclusion'],
      workToDo: json['travailAFaire'],
      workToDoDocuments: List<Attachment>.from(json['documentsTAF']['V'].map((el) => Attachment.fromJSON(session, json))),
      circumstances: json['circonstances'],
      circumstancesDocuments: List<Attachment>.from(json['documentsCirconstances']['V'].map((el) => Attachment.fromJSON(session, json))),
      giver: json['demandeur']['V']['L'],
      dateGiven: decodePronoteDate(json['dateDemande']['V']),
      durationMinutes: json['duree']
    );
  }

  NotebookPunishment({required this.id, required this.title, required this.reasons, required this.isDuringLesson, required this.exclusion, required this.workToDo, required this.workToDoDocuments, required this.circumstances, required this.circumstancesDocuments, required this.giver, required this.dateGiven, required this.durationMinutes});
}