import 'package:pronote_dart/src/core/clients/student.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/account.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';

extension PronoteStudentAccount on PronoteStudentClient {
  Future<Account> account() async {
    final request = Request(session, 'PageInfosPerso', {
      '_Signature_': {'onglet': TabLocation.account.code}
    });

    final response = await request.send();

    return Account.fromJSON(session, response.data['donnees']);
  }
}
