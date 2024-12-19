import 'package:pronote_dart/src/api/private/student/homework.dart';
import 'package:pronote_dart/src/core/clients/student.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/resource.dart';

extension PronoteStudentResources on PronoteStudentClient {
  Future<Resource> resource(String resourceID) async {
    final request = Request(session, 'donneesContenusCDT', {
      '_Signature_': { 'onglet': TabLocation.resources.code },
      'donnees': {
        'cahierDeTextes': { 'N': resourceID }
      }
    });

    final response = await request.send();

    final resource = response.data['donnees']['ListeCahierDeTextes']['V'][0];
    return Resource.fromJSON(session, resource);
  }

  List<Resource> _decoder(dynamic data) {
    return List<Resource>.from(data['ListeCahierDeTextes']['V'].map((el) => Resource.fromJSON(session, el)));
  }

  Future<List<Resource>> resourcesFromWeek(int weekNumber, [int? extendsToWeekNumber]) async {
    final reply = await homeworkFromWeek(TabLocation.resources, weekNumber, extendsToWeekNumber);
    return _decoder(reply);
  }

  Future<List<Resource>> resourcesFromIntervals(DateTime startDate, DateTime endDate) async {
    final reply = await homeworkFromIntervals(TabLocation.resources, startDate, endDate);
    return List<Resource>.from(_decoder(reply).where((el) => (startDate.isBefore(el.endDate) || startDate.isAtSameMomentAs(el.endDate)) && (endDate.isAfter(el.endDate) || endDate.isAtSameMomentAs(el.endDate))));
  }
}