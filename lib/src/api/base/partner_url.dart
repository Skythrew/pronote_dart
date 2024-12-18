import 'package:pronote_dart/src/core/clients/base.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/partner.dart';

extension PronoteBasePartnerURL on PronoteBaseClient {
  Future<String> partnerURL(Partner partner) async {
    final request = Request(session, 'SaisieURLPartenaire', {
      '_Signature_': {
        'onglet': TabLocation.presence.code
      },

      'donnees': {
        'SSO': partner.sso
      }
    });

    final response = await request.send();
    return response.data['RapportSaisie']['urlSSO']['V'];
  }
}