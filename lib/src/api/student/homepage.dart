import 'package:pronote_dart/src/core/clients/student.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/homepage.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';
import 'package:pronote_dart/src/utils/week_number.dart';

extension PronoteStudentHomepage on PronoteStudentClient {
  /// Retrieve data from the student's homepage.
  Future<Homepage> homepage({DateTime? day}) async {
    day ??= session.instance.nextBusinessDay;

    final weekNumber = translateToWeekNumber(day, session.instance.firstMonday);
    final next = encodePronoteDate(day);

    final request = Request(session, 'PageAccueil', {
      '_Signature_': {
        'onglet': TabLocation.presence.code
      },

      'donnees': {
        'avecConseilDeClasse': true,

        'dateGrille': {
          '_T': 7,
          'V': next
        },

        'numeroSemaine': weekNumber,

        'coursNonAssures': {
          'numeroSemaine': weekNumber
        },

        'personnelsAbsents': {
          'numeroSemaine': weekNumber
        },

        'incidents': {
          'numeroSemaine': weekNumber
        },

        'exclusions': {
          'numeroSemaine': weekNumber
        },

        'donneesVS': {
          'numeroSemaine': weekNumber
        },

        'registreAppel': {
          'date': {
            '_T': 7,
            'V': next
          }
        },

        'previsionnelAbsServiceAnnexe': {
          'date': {
            '_T': 7,
            'V': next
          }
        },

        'donneesProfs': {
          'numeroSemaine': weekNumber
        },

        'EDT': {
          'numeroSemaine': weekNumber
        },

        'TAFARendre': {
          'date': {
            '_T': 7,
            'V': next
          }
        },

        'TAFEtActivites': {
          'date': {
            '_T': 7,
            'V': next
          }
        },

        'partenaireCDI': {
          'CDI': {}
        },

        'tableauDeBord': {
          'date': {
            '_T': 7,
            'V': next
          }
        },

        'modificationsEDT': {
          'date': {
            '_T': 7,
            'V': next
          }
        }
      }
    });

    final response = await request.send();

    return Homepage.fromJSON(response.data['donnees']);
  }
}