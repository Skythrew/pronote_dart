import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/instance_parameters.dart';
import 'package:pronote_dart/src/models/session.dart';

Future<InstanceParameters> instanceParameters(
    Session session, String navigatorIdentifier) async {
  final sessionInfo = session.information;
  final encrypter = Encrypter(RSA(
      publicKey: RSAPublicKey(BigInt.parse(sessionInfo.rsaModulus, radix: 16),
          BigInt.parse(sessionInfo.rsaExponent, radix: 16))));

  final aesIV = sessionInfo.aesIV;

  String uuid;

  if (sessionInfo.rsaFromConstants) {
    uuid = base64Encode(
        sessionInfo.http ? encrypter.encryptBytes(aesIV).bytes : aesIV);
  } else {
    uuid = base64Encode(encrypter.encryptBytes(aesIV).bytes);
  }

  final request = Request(session, 'FonctionParametres', {
    'donnees': {'identifiantNav': navigatorIdentifier, 'Uuid': uuid}
  });

  final response = await request.send();

  return InstanceParameters.fromJSON(response.data['donnees']);
}
