import 'package:pronote_dart/src/core/clients/base.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';

extension PronoteBasePresence on PronoteBaseClient {
  Future<void> presence() async {
    final request = Request(session, 'Presence', {
      '_Signature_': { 'onglet': TabLocation.presence.code }
    });

    await request.send();
  }
}