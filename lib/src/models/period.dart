import 'package:pronote_dart/src/utils/pronote_date.dart';

class Period {
  final String id;
  final String name;
  final num kind;
  final DateTime startDate;
  final DateTime endDate;

  factory Period.fromJSON(Map<String, dynamic> json) {
    return Period(
        json['N'],
        json['L'],
        json['G'],
        decodePronoteDate(json['dateDebut']['V']),
        decodePronoteDate(json['dateFin']['V']));
  }

  Map<String, dynamic> encode() {
    return {'N': id, 'G': kind, 'L': name};
  }

  Period(this.id, this.name, this.kind, this.startDate, this.endDate);
}
