import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/account.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/session.dart';

Future<Account> account(Session session) async {
  final request = Request(session, 'PageInfosPerso', {
    '_Signature_': {'onglet': TabLocation.account.code}
  });

  final response = await request.send();

  return Account.fromJSON(session, response.data['donnees']);
}
