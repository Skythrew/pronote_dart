import 'package:pronote_dart/src/utils/pronote_date.dart';

class NotebookDelay {
  final String id;

  final DateTime date;

  final int minutes;

  final bool justified;

  final String? justification;

  final bool shouldParentsJustify;
  final bool administrativelyFixed;
  final bool isReasonUnknown;

  final String? reason;

  factory NotebookDelay.fromJSON(Map<String, dynamic> json) {
    final bool isReasonUnknown = json['estMotifNonEncoreConnu'];
    final bool justified = json['justifie'];

    return NotebookDelay(
      id: json['N'],
      date: decodePronoteDate(json['date']['V']),
      minutes: json['duree'],
      justified: justified,
      justification: (justified) ? json['justification'] : null,
      shouldParentsJustify: json['aJustifierParParents'],
      administrativelyFixed: json['reglee'],
      isReasonUnknown: isReasonUnknown,
      reason: (!isReasonUnknown) ? json['listeMotifs']['V'][0]['L'] : null
    );
  }

  NotebookDelay({required this.id, required this.date, required this.minutes, required this.justified, required this.justification, required this.shouldParentsJustify, required this.administrativelyFixed, required this.isReasonUnknown, required this.reason});
}