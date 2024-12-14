import 'package:pronote_dart/src/utils/domain_decoder.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

import 'package:pronote_dart/src/models/period.dart';
import 'package:pronote_dart/src/models/holiday.dart';
import 'package:pronote_dart/src/models/week_frequency.dart';

class InstanceParameters {
  final DateTime nextBusinessDay;
  final DateTime firstMonday;
  final DateTime firstDate;
  final DateTime lastDate;

  /// Allows to recognize the device for next authentications.
  final String navigatorIdentifier;
  final List<num> version;
  final List<String> endings;
  final List<Period> periods;
  final List<Holiday> holidays;
  final Map<num, WeekFrequency> weekFrequencies;
  final num blocksPerDay;

  factory InstanceParameters.fromJSON(Map<String, dynamic> json) {
    final Map<num, WeekFrequency> weekFrequencies = {};

    for (final fortnight in [1, 2]) {
      final frequency =
          decodeDomain(json['General']['DomainesFrequences'][fortnight]['V']);

      for (final week in frequency) {
        weekFrequencies[week] = WeekFrequency(
            json['General']['LibellesFrequences'][fortnight], fortnight);
      }
    }

    return InstanceParameters(
        decodePronoteDate(json['General']['JourOuvre']['V']),
        decodePronoteDate(json['General']['PremierLundi']['V']),
        decodePronoteDate(json['General']['PremiereDate']['V']),
        decodePronoteDate(json['General']['DerniereDate']['V']),
        json['identifiantNav'],
        List<num>.from(json['General']['versionPN'].split('.').map((el) {
          return int.parse(el);
        })),
        List<String>.from(json['General']['ListeHeuresFin']['V'].map((ending) {
          return ending['L'];
        })),
        List<Period>.from(json['General']['ListePeriodes'].map((el) {
          return Period.fromJSON(el);
        })),
        List<Holiday>.from(json['General']['listeJoursFeries']['V'].map((el) {
          return Holiday.fromJSON(el);
        })),
        weekFrequencies,
        json['General']['PlacesParJour']);
  }

  InstanceParameters(
      this.nextBusinessDay,
      this.firstMonday,
      this.firstDate,
      this.lastDate,
      this.navigatorIdentifier,
      this.version,
      this.endings,
      this.periods,
      this.holidays,
      this.weekFrequencies,
      this.blocksPerDay);
}
