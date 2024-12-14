import 'package:pronote_dart/src/api/private/homework.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/assignment.dart';
import 'package:pronote_dart/src/models/enums/entity_state.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/session.dart';

Future<List<Assignment>> assignmentsFromWeek(Session session, int weekNumber,
    [int? extendsToWeekNumber]) async {
  final reply = await homeworkFromWeek(
      session, TabLocation.assignments, weekNumber, extendsToWeekNumber);
  return List<Assignment>.from(reply['ListeTravauxAFaire']['V']
      .map((el) => Assignment.fromJSON(session, el)));
}

Future<List<Assignment>> assignmentsFromIntervals(
    Session session, DateTime startDate, DateTime endDate) async {
  final reply = await homeworkFromIntervals(
      session, TabLocation.assignments, startDate, endDate);
  return List<Assignment>.from(reply['ListeTravauxAFaire']['V']
      .map((el) => Assignment.fromJSON(session, el))
      .where((el) =>
          (startDate.isBefore(el.deadline) ||
              startDate.isAtSameMomentAs(el.deadline)) &&
          (endDate.isAfter(el.deadline) ||
              endDate.isAtSameMomentAs(el.deadline))));
}

Future<void> assignmentStatus(
    Session session, String assignmentID, bool done) async {
  final request = Request(session, 'SaisieTAFFaitEleve', {
    '_Signature_': {'onglet': TabLocation.assignments.code},
    'donnees': {
      'listeTAF': [
        {'E': EntityState.modification.code, 'TAFFait': done, 'N': assignmentID}
      ]
    }
  });

  await request.send();
}
