import 'package:pronote_dart/src/utils/pronote_date_decoder.dart';

class Holiday {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  factory Holiday.fromJSON(Map<String, dynamic> json) {
    return Holiday(
        json['N'],
        json['L'],
        decodePronoteDate(json['dateDebut']['V']),
        decodePronoteDate(json['dateFin']['V']));
  }

  Holiday(this.id, this.name, this.startDate, this.endDate);
}
