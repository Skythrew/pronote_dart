import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/period.dart';

class Tab {
  final Period? defaultPeriod;
  final TabLocation location;
  final List<Period> periods;

  factory Tab.fromJSON(
      Map<String, dynamic> json, List<Period> instancePeriods) {
    find(String? id) => instancePeriods.firstWhere((p2) => p2.id == id);

    final defaultPeriod = (json['periodeParDefaut'] != null)
        ? find(json['periodeParDefaut']['V']['N'])
        : null;

    final List<Period> periods = [];

    for (final jsonPeriod in json['listePeriodes']['V']) {
      for (final instancePeriod in instancePeriods) {
        if (instancePeriod.id == jsonPeriod['id']) {
          periods.add(instancePeriod);
          continue;
        }
      }
    }

    return Tab(defaultPeriod, TabLocation.fromInt(json['G'])!, periods);
  }

  Tab(this.defaultPeriod, this.location, this.periods);
}
