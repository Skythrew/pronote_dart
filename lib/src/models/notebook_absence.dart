import 'package:pronote_dart/src/utils/pronote_date.dart';

class NotebookAbsence {
  final String id;
  
  final DateTime startDate;
  final DateTime endDate;

  final bool justified;
  final bool opened;

  final num daysMissed;
  final int hoursMissed;
  final int minutesMissed;

  final bool shouldParentsJustify;
  final bool administrativelyFixed;

  final bool isReasonUnknown;
  final String? reason;

  factory NotebookAbsence.fromJSON(Map<String, dynamic> json) {
    final [hoursMissed, minutesMissed] = List<int>.from(json['NbrHeures'].toString().split('h').map((el) => int.parse(el)));
    final bool isReasonUnknown = json['estMotifNonEncoreConnu'];

    return NotebookAbsence(
      id: json['N'],
      startDate: decodePronoteDate(json['dateDebut']['V']),
      endDate: decodePronoteDate(json['dateFin']['V']),
      justified: json['justifie'],
      opened: json['ouverte'],
      daysMissed: json['NbrJours'],
      hoursMissed: hoursMissed,
      minutesMissed: minutesMissed,
      shouldParentsJustify: json['aJustifierParParents'],
      administrativelyFixed: json['reglee'],
      isReasonUnknown: isReasonUnknown,
      reason: (!isReasonUnknown) ? json['listeMotifs']['V'][0]['L'] : null
    );
  }

  NotebookAbsence({required this.id, required this.startDate, required this.endDate, required this.justified, required this.opened, required this.daysMissed, required this.hoursMissed, required this.minutesMissed, required this.shouldParentsJustify, required this.administrativelyFixed, required this.isReasonUnknown, required this.reason});
}