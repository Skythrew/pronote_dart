import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:pronote_dart/src/core/aes_helper.dart';
import 'package:pronote_dart/src/models/enums/account_kind.dart';
import 'package:pronote_dart/src/models/errors/bad_credentials_error.dart';
import 'package:pronote_dart/src/models/session.dart';

class CredentialsAuth {
  String username;
  String? token;
  String? password;

  CredentialsAuth(
      {required this.username, required this.token, required this.password});
}

class LoginInfos {
  final String token;
  final String username;
  final AccountKind kind;
  final String url;
  final String? navigatorIdentifier;

  LoginInfos(
      this.token, this.username, this.kind, this.url, this.navigatorIdentifier);
}

enum ModProperty { token, password }

void transformCredentials(
    CredentialsAuth auth, ModProperty modProperty, dynamic identity) {
  if (identity['modeCompLog'] == 1) {
    auth.username = auth.username.toLowerCase();
  }

  if (identity['modeCompMdp'] == 1) {
    switch (modProperty) {
      case ModProperty.token:
        auth.token = auth.token!.toLowerCase();
        break;
      case ModProperty.password:
        auth.password = auth.password!.toLowerCase();
        break;
    }
  }
}

Uint8List createMiddlewareKey(dynamic identity, String username, String mod) {
  final hash = sha256.convert(utf8.encode('${identity['alea'] ?? ''}$mod'));

  return utf8.encode('$username${hash.toString().toUpperCase()}');
}

String solveChallenge(Session session, dynamic identity, Uint8List key) {
  final iv = session.information.aesIV;

  try {
    final bytes = AESHelper.decrypt(
        HEX.decode(identity['challenge']) as Uint8List, key, iv);

    String solution = '';

    for (int i = 0; i < bytes.length; i++) {
      if (i % 2 == 0) {
        solution += bytes[i];
      }
    }

    return AESHelper.encrypt(utf8.encode(solution), key, iv, false);
  } catch (e) {
    throw BadCredentialsError();
  }
}
