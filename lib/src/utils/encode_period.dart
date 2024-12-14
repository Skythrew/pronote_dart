import 'package:pronote_dart/src/models/period.dart';

Map<String, dynamic> encodePeriod(Period period) {
  return {'N': period.id, 'G': period.kind, 'L': period.name};
}
