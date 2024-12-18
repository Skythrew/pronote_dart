import 'package:pronote_dart/src/core/clients/student.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/assignment.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';

extension PronoteStudentResourceAssignments on PronoteStudentClient {
  Future<List<Assignment>> resourceAssignments(String resourceID) async {
    final request = Request(session, 'donneesContenusCDT', {
      '_Signature_': { 'onglet': TabLocation.resources.code },

      'donnees': {
        'pourTAF': true,
        'cahierDeTextes': { 'N': resourceID }
      }
    });

    final response = await request.send();

    return List<Assignment>.from(response.data['donnees']['ListeCahierDeTextes']['V'][0]['ListeTravailAFaire']['V']
      .map((el) => Assignment.fromJSON(session, el)));
  }
}