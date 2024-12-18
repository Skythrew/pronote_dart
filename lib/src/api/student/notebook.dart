import 'package:pronote_dart/src/core/clients/student.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/notebook.dart';
import 'package:pronote_dart/src/models/period.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

extension PronoteStudentNotebook on PronoteStudentClient {
  Future<Notebook> notebook(Period period) async {
    final request = Request(session, 'PagePresence', {
      '_Signature_': {
        'onglet': TabLocation.notebook.code
      },

      'donnees': {
        'periode': period.encode(),

        'DateDebut': {
          '_T': 7,
          'V': encodePronoteDate(period.startDate)
        },

        'DateFin': {
          '_T': 7,
          'V': encodePronoteDate(period.endDate)
        }
      }
    });
  
    final response = await request.send();
    return Notebook.fromJSON(session, response.data['donnees']);
  }
}