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
}