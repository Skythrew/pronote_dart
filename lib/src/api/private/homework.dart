import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/utils/week_number.dart';

Future<dynamic> homeworkFromWeek(
    Session session, TabLocation tab, int weekNumber,
    [int? extendsToWeekNumber]) async {
  final request = Request(session, 'PageCahierDeTexte', {
    '_Signature_': {'onglet': tab.code},
    'donnees': {
      'domaine': {
        '_T': 8,
        'V': extendsToWeekNumber is int
            ? '[$weekNumber..$extendsToWeekNumber]'
            : '[$weekNumber]'
      }
    }
  });

  final response = await request.send();
  return response.data['donnees'];
}

Future<dynamic> homeworkFromIntervals(Session session, TabLocation tab,
    DateTime startDate, DateTime endDate) async {
  startDate = startDate.toUtc();
  endDate = endDate.toUtc();

  final startWeekNumber =
      translateToWeekNumber(startDate, session.instance.firstMonday);
  final endWeekNumber =
      translateToWeekNumber(endDate, session.instance.firstMonday);

  return homeworkFromWeek(session, tab, startWeekNumber, endWeekNumber);
}
