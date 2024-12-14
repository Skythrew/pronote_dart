import 'package:pronote_dart/src/models/session.dart';

({int hours, int minutes}) translatePositionToTimings(
    Session session, int position) {
  if (position > session.instance.endings.length) {
    position %= (session.instance.endings.length - 1);
  }

  final formatted = session.instance.endings[position];

  final [hours, minutes] =
      formatted.split('h').map((e) => int.parse(e)).toList();

  return (hours: hours, minutes: minutes);
}
