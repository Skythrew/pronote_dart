import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/session.dart';

Future<dynamic> identify(
    Session session,
    bool requestFirstMobileAuthentication,
    bool reuseMobileAuth,
    bool requestFromQRCode,
    bool useCAS,
    String username,
    String deviceUUID) async {
  final request = Request(session, 'Identification', {
    'donnees': {
      'genreConnexion': 0,
      'genreEspace': session.information.accountKind.code,
      'identifiant': username,
      'pourENT': useCAS,
      'enConnexionAuto': false,
      'enConnexionAppliMobile': reuseMobileAuth,
      'demandeConnexionAuto': false,
      'demandeConnexionAppliMobile': requestFirstMobileAuthentication,
      'demandeConnexionAppliMobileJeton': requestFromQRCode,
      'uuidAppliMobile': deviceUUID,
      'loginTokenSAV': ''
    }
  });

  final response = await request.send();
  return response.data['donnees'];
}
