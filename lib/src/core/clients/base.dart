import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pronote_dart/src/core/aes_helper.dart';
import 'package:pronote_dart/src/core/request.dart';

import 'package:pronote_dart/src/models/enums/account_kind.dart';
import 'package:pronote_dart/src/models/errors/access_denied_error.dart';
import 'package:pronote_dart/src/models/errors/account_disabled_error.dart';
import 'package:pronote_dart/src/models/errors/bad_credentials_error.dart';
import 'package:pronote_dart/src/models/errors/busy_page_error.dart';
import 'package:pronote_dart/src/models/errors/page_unavailable_error.dart';
import 'package:pronote_dart/src/models/errors/suspended_ip_error.dart';
import 'package:pronote_dart/src/models/instance_parameters.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/session_information.dart';
import 'package:pronote_dart/src/models/user_parameters.dart';
import 'package:pronote_dart/src/utils/clean_url.dart';

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

class PronoteBaseClient {
  final Session session = Session();

  Future<SessionInformation> _sessionInformation(String base,
      AccountKind kind, Map<String, dynamic> params) async {
    final List<String> queryParams = [];
    params.forEach((k, v) {
      queryParams.add('$k=$v');
    });

    final uri = Uri.parse(
        '$base/${kind.encodeToPath()}?${queryParams.join('&')}');

    final html = (await http.get(uri)).body;

    try {
      final bodyCleaned = html.replaceAll(' ', '').replaceAll('\n', '');

      final from = 'Start(';
      final to = ')}catch';

      final relaxedData = bodyCleaned.substring(
          bodyCleaned.indexOf(from) + from.length, bodyCleaned.indexOf(to));

      final sessionData = relaxedData
          .replaceAllMapped(RegExp('([\'"])?([a-z0-9A-Z_]+)([\'"])?:'), (match) {
        return '"${match.group(2)}": ';
      }).replaceAll('\'', '"');

      return SessionInformation.fromJSON(jsonDecode(sessionData), base);
    } catch (e) {
      if (html.contains('Votre adresse IP est provisoirement suspendue')) {
        throw SuspendedIpError();
      } else if (html.contains('Le site n\'est pas disponible')) {
        throw PageUnavailableError();
      } else if (html.contains('Le site est momentanément indisponible')) {
        throw BusyPageError();
      }

      throw PageUnavailableError();
    }
  }

  Future<InstanceParameters> _instanceParameters(
    String navigatorIdentifier) async {
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

  Future<dynamic> _identify(
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

  Future<UserParameters> _userParameters() async {
    final request = Request(session, 'ParametresUtilisateur', {});
    final response = await request.send();
    return UserParameters.fromJSON(session, response.data['donnees']);
  }

  Future<dynamic> _authenticate(String challenge) async {
    final request = Request(session, 'Authentification', {
      'donnees': {
        'connexion': 0,
        'challenge': challenge,
        'espace': session.information.accountKind.code
      }
    });

    final response = await request.send();
    final data = response.data['donnees'];

    if (data['Acces'] is num && data['Acces'] != 0) {
      switch (data['Acces']) {
        case 1:
          throw BadCredentialsError();
        case 2:
        case 3:
        case 4:
        case 5:
        case 7:
        case 8:
          throw AccessDeniedError();

        case 6:
        case 10:
          throw AccountDisabledError();
        case 9:
          if (data['AccesMessage'] != null) {
            String error = data['AccesMessage']['message'] ?? '(none)';

            if (data['AccesMessage']['titre'] != null) {
              error += '${data['AccesMessage']['titre']} $error';
            }

            throw Exception(error);
          }
      }
    }

    return data;
  }

  void _switchToAuthKey(dynamic authentication, Uint8List key) {
    final iv = session.information.aesIV;
    final decryptedAuthKey = AESHelper.decrypt(
        HEX.decode(authentication['cle']) as Uint8List, key, iv);
    final authKey =
        decryptedAuthKey.split(',').map((char) => int.parse(char)).toList();

    session.information.aesKey = Uint8List.fromList(authKey);
  }

  Future<LoginInfos> _finishLoginManually(dynamic auth,
    dynamic identity, String? initialUsername) async {
    session.user = await _userParameters();
    session.use(0);

    return LoginInfos(
        auth['jetonConnexionAppliMobile'],
        identity['login'] ?? initialUsername,
        session.information.accountKind,
        session.information.url,
        session.instance.navigatorIdentifier);
  }

  void _transformCredentials(
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

  Uint8List _createMiddlewareKey(dynamic identity, String username, String mod) {
    final hash = sha256.convert(utf8.encode('${identity['alea'] ?? ''}$mod'));

    return utf8.encode('$username${hash.toString().toUpperCase()}');
  }

  String _solveChallenge(Session session, dynamic identity, Uint8List key) {
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

  Future<LoginInfos> loginWithCredentials(
      String url,
      String username,
      String password,
      AccountKind kind,
      String deviceUUID,
      String? navigatorIdentifier) async {
    final base = cleanURL(url);

    session.information = await _sessionInformation(base, kind, {
      'fd': 1,
      'login': true,
      'bydlg': 'A6ABB224-12DD-4E31-AD3E-8A39A1C2C335'
    });

    session.instance =
        await _instanceParameters(navigatorIdentifier ?? '');

    final identity =
        await _identify(true, false, false, false, username, deviceUUID);

    final auth =
        CredentialsAuth(username: username, token: null, password: password);
    _transformCredentials(auth, ModProperty.password, identity);
    final key = _createMiddlewareKey(identity, auth.username, auth.password!);

    final challenge = _solveChallenge(session, identity, key);
    final authentication = await _authenticate(challenge);
    _switchToAuthKey(authentication, key);

    return _finishLoginManually(authentication, identity, username);
  }
}