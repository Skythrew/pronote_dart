import 'package:pronote_dart/src/models/notebook_absence.dart';
import 'package:pronote_dart/src/models/notebook_delay.dart';
import 'package:pronote_dart/src/models/notebook_observation.dart';
import 'package:pronote_dart/src/models/notebook_precautionary_measure.dart';
import 'package:pronote_dart/src/models/notebook_punishment.dart';
import 'package:pronote_dart/src/models/session.dart';

class Notebook {
  final List<NotebookAbsence> absences;
  final List<NotebookDelay> delays;
  final List<NotebookPunishment> punishments;
  final List<NotebookObservation> observations;
  final List<NotebookPrecautionaryMeasure> precautionaryMeasures;

  factory Notebook.fromJSON(Session session, Map<String, dynamic> json) {
    final List<NotebookAbsence> absences = [];
    final List<NotebookDelay> delays = [];
    final List<NotebookPunishment> punishments = [];
    final List<NotebookObservation> observations = [];
    final List<NotebookPrecautionaryMeasure> precautionaryMeasures = [];

    for (final item in json['listeAbsences']['V']) {
      switch (item['G']) {
        case 13:
          absences.add(NotebookAbsence.fromJSON(item));
          break;
        case 14:
          delays.add(NotebookDelay.fromJSON(item));
          break;
        case 41:
          punishments.add(NotebookPunishment.fromJSON(session, item));
          break;
        case 46:
          observations.add(NotebookObservation.fromJSON(item));
          break;
        case 72:
          precautionaryMeasures.add(NotebookPrecautionaryMeasure.fromJSON(session, item));
          break;
      }
    }

    return Notebook(
      absences: absences,
      delays: delays,
      punishments: punishments,
      observations: observations,
      precautionaryMeasures: precautionaryMeasures
    );
  }
  
  Notebook({required this.absences, required this.delays, required this.punishments, required this.observations, required this.precautionaryMeasures});
}