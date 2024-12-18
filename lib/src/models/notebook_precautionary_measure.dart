import 'package:pronote_dart/src/models/attachment.dart';
import 'package:pronote_dart/src/models/enums/establishment_access_kind.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/utils/domain_decoder.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

class NotebookPrecautionaryMeasure {
  final String id;
  final String title;
  final String comments;
  final List<String> reasons;

  final bool exclusion;

  final String circumstances;
  final List<Attachment> circumstancesDocuments;

  final String decisionMaker;
  final String giver;
  final DateTime dateGiven;
  final DateTime startDate;
  final DateTime endDate;

  final List<EstablishmentAccessKind> disallowedAccesses;

  factory NotebookPrecautionaryMeasure.fromJSON(Session session, Map<String, dynamic> json) {
    return NotebookPrecautionaryMeasure(
      id: json['N'],
      title: json['nature']['V']['L'],
      comments: json['commentaire'],
      reasons: List<String>.from(json['listeMotifs']['V'].map((el) => el['L'])),
      exclusion: json['estUneExclusion'],
      circumstances: json['circonstances'],
      circumstancesDocuments: List<Attachment>.from(json['documentsCirconstances']['V'].map((doc) => Attachment.fromJSON(session, doc))),
      decisionMaker: json['decideur']['V']['L'],
      giver: json['demandeur']['V']['L'],
      dateGiven: decodePronoteDate(json['dateDemande']['V']),
      startDate: decodePronoteDate(json['dateDebut']['V']),
      endDate: decodePronoteDate(json['dateFin']['V']),
      disallowedAccesses: List<EstablishmentAccessKind>.from(decodeDomain(json['interditAcces']['V']).map((el) => EstablishmentAccessKind.fromInt(el)))
    );
  }

  NotebookPrecautionaryMeasure({required this.id, required this.title, required this.comments, required this.reasons, required this.exclusion, required this.circumstances, required this.circumstancesDocuments, required this.decisionMaker, required this.giver, required this.dateGiven, required this.startDate, required this.endDate, required this.disallowedAccesses});
}