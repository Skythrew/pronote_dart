import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/export.dart';
import 'package:pronote_dart/src/core/aes_helper.dart';
import 'package:pronote_dart/src/core/login.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/encoders/account_kind.dart';
import 'package:pronote_dart/src/models/account.dart';
import 'package:pronote_dart/src/models/assignment.dart';
import 'package:pronote_dart/src/models/enums/account_kind.dart';
import 'package:pronote_dart/src/models/enums/entity_state.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/errors/access_denied_error.dart';
import 'package:pronote_dart/src/models/errors/bad_credentials_error.dart';
import 'package:pronote_dart/src/models/errors/busy_page_error.dart';
import 'package:pronote_dart/src/models/errors/page_unavailable_error.dart';
import 'package:pronote_dart/src/models/errors/suspended_ip_error.dart';
import 'package:pronote_dart/src/models/grades_overview.dart';
import 'package:pronote_dart/src/models/instance_parameters.dart';
import 'package:pronote_dart/src/models/period.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/session_information.dart';
import 'package:http/http.dart' as http;
import 'package:pronote_dart/src/models/timetable.dart';
import 'package:pronote_dart/src/models/user_parameters.dart';
import 'package:pronote_dart/src/utils/clean_url.dart';

import 'package:pronote_dart/src/models/errors/account_disabled_error.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';
import 'package:pronote_dart/src/utils/week_number.dart';

class PronoteClient {
  final session = Session();

  final Map<String, String> _headers = {};

  Future<String> _get(Uri url) async {
    return (await http.get(url, headers: _headers)).body;
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

  Future<SessionInformation> _sessionInformation(
      String base, AccountKind kind, Map<String, dynamic> params) async {
    final List<String> queryParams = [];
    params.forEach((k, v) {
      queryParams.add('$k=$v');
    });

    final uri = Uri.parse(
        '$base/${encodeAccountKindToPath(kind)}?${queryParams.join('&')}');

    final html = await _get(uri);

    try {
      final bodyCleaned = html.replaceAll(' ', '').replaceAll('\n', '');

      final from = 'Start(';
      final to = ')}catch';

      final relaxedData = bodyCleaned.substring(
          bodyCleaned.indexOf(from) + from.length, bodyCleaned.indexOf(to));

      final sessionData = relaxedData.replaceAllMapped(
          RegExp('([\'"])?([a-z0-9A-Z_]+)([\'"])?:'), (match) {
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

  void switchToAuthKey(dynamic authentication, Uint8List key) {
    final iv = session.information.aesIV;
    final decryptedAuthKey = AESHelper.decrypt(
        HEX.decode(authentication['cle']) as Uint8List, key, iv);
    final authKey =
        decryptedAuthKey.split(',').map((char) => int.parse(char)).toList();

    session.information.aesKey = Uint8List.fromList(authKey);
  }

  Future<UserParameters> _userParameters() async {
    final request = Request(session, 'ParametresUtilisateur', {});
    final response = await request.send();
    return UserParameters.fromJSON(session, response.data['donnees']);
  }

  Future<LoginInfos> _finishLoginManually(
      dynamic auth, dynamic identity, String? initialUsername) async {
    session.user = await _userParameters();
    use(0);

    return LoginInfos(
        auth['jetonConnexionAppliMobile'],
        identity['login'] ?? initialUsername,
        session.information.accountKind,
        session.information.url,
        session.instance.navigatorIdentifier);
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

    session.instance = await _instanceParameters(navigatorIdentifier ?? '');

    final identity =
        await _identify(true, false, false, false, username, deviceUUID);

    final auth =
        CredentialsAuth(username: username, token: null, password: password);
    transformCredentials(auth, ModProperty.password, identity);
    final key = createMiddlewareKey(identity, auth.username, auth.password!);

    final challenge = solveChallenge(session, identity, key);
    final authentication = await _authenticate(challenge);
    switchToAuthKey(authentication, key);

    return _finishLoginManually(authentication, identity, username);
  }

  /// Makes the client use another user resource.
  void use(int index) {
    session.userResource = session.user.resources[index];
  }

  /// Gets grades overview for a specific period.
  /// Including student's grades with averages and the global averages.
  Future<GradesOverview> gradesOverview(Period period) async {
    final request = Request(session, 'DernieresNotes', {
      '_Signature_': {'onglet': TabLocation.grades.code},
      'donnees': {'Periode': period.encode()}
    });

    final response = await request.send();

    return GradesOverview.fromJSON(session, response.data['donnees']);
  }

  Future<String> gradeReportPDF(Period period) async {
    final request = Request(session, 'GenerationPDF', {
      'donnees': {
        'avecCodeCompetences': false,
        'genreGenerationPDF': 2,
        'options': {
          'adapterHauteurService': false,
          'desEleves': false,
          'gererRectoVerso': false,
          'hauteurServiceMax': 15,
          'hauteurServiceMin': 10,
          'piedMonobloc': true,
          'portrait': true,
          'taillePolice': 6.5,
          'taillePoliceMin': 5,
          'taillePolicePied': 6.5,
          'taillePolicePiedMin': 5
        },
        'periode': period.encode()
      },
      '_Signature_': {'onglet': TabLocation.gradebook.code}
    });

    final response = await request.send();
    return '${session.information.url}/${Uri.encodeComponent(response.data['donnees']['url']['V'])}';
  }

  Future<Timetable> timetable(
      [Map<String, dynamic> additional = const {}]) async {
    final request = Request(session, 'PageEmploiDuTemps', {
      '_Signature_': {'onglet': TabLocation.timetable.code},
      'donnees': {
        'estEDTAnnuel': false,
        'estEDTPermanence': false,
        'avecAbsencesEleve': false,
        'avecRessourcesLibrePiedHoraire': false,
        'avecAbsencesRessource': true,
        'avecInfosPrefsGrille': true,
        'avecConseilDeClasse': true,
        'avecCoursSortiePeda': true,
        'avecDisponibilites': true,
        'avecRetenuesEleve': true,
        'edt': {'G': 16, 'L': 'Emploi du temps'},
        'ressource': session.userResource.encode(),
        'Ressource': session.userResource.encode(),
        ...additional
      }
    });

    final response = await request.send();

    return Timetable.fromJSON(session, response.data['donnees']);
  }

  Future<Timetable> timetableFromWeek(int weekNumber) async {
    return await timetable(
        {'numeroSemaine': weekNumber, 'NumeroSemaine': weekNumber});
  }

  Future<Timetable> timetableFromIntervals(
      DateTime startDate, DateTime? endDate) async {
    final endDateParam = {};

    if (endDate != null) {
      final endDateMap = {'_T': 7, 'V': encodePronoteDate(endDate)};

      endDateParam['dateFin'] = endDateMap;
      endDateParam['DateFin'] = endDateMap;
    }

    return timetable({
      'dateDebut': {'_T': 7, 'V': encodePronoteDate(startDate)},
      'DateDebut': {'_T': 7, 'V': encodePronoteDate(startDate)},
      ...endDateParam
    });
  }

  Future<dynamic> _homeworkFromWeek(TabLocation tab, int weekNumber,
      [int? extendsToWeekNumber]) async {
    final request = Request(session, 'PageCahierDeTexte', {
      '_Signature_': {'onglet': tab.code},
      'donnees': {
        'domaine': {
          '_T': 8,
          'V': extendsToWeekNumber is int
              ? '[$weekNumber..$extendsToWeekNumber]'
              : '[$weekNumber]'
        }
      }
    });

    final response = await request.send();
    return response.data['donnees'];
  }

  Future<dynamic> _homeworkFromIntervals(
      TabLocation tab, DateTime startDate, DateTime endDate) async {
    startDate = startDate.toUtc();
    endDate = endDate.toUtc();

    final startWeekNumber =
        translateToWeekNumber(startDate, session.instance.firstMonday);
    final endWeekNumber =
        translateToWeekNumber(endDate, session.instance.firstMonday);

    return _homeworkFromWeek(tab, startWeekNumber, endWeekNumber);
  }

  Future<List<Assignment>> assignmentsFromWeek(int weekNumber,
      [int? extendsToWeekNumber]) async {
    final reply = await _homeworkFromWeek(
        TabLocation.assignments, weekNumber, extendsToWeekNumber);
    return List<Assignment>.from(reply['ListeTravauxAFaire']['V']
        .map((el) => Assignment.fromJSON(session, el)));
  }

  Future<List<Assignment>> assignmentsFromIntervals(
      DateTime startDate, DateTime endDate) async {
    final reply = await _homeworkFromIntervals(
        TabLocation.assignments, startDate, endDate);
    return List<Assignment>.from(reply['ListeTravauxAFaire']['V']
        .map((el) => Assignment.fromJSON(session, el))
        .where((el) =>
            (startDate.isBefore(el.deadline) ||
                startDate.isAtSameMomentAs(el.deadline)) &&
            (endDate.isAfter(el.deadline) ||
                endDate.isAtSameMomentAs(el.deadline))));
  }

  Future<void> assignmentStatus(String assignmentID, bool done) async {
    final request = Request(session, 'SaisieTAFFaitEleve', {
      '_Signature_': {'onglet': TabLocation.assignments.code},
      'donnees': {
        'listeTAF': [
          {
            'E': EntityState.modification.code,
            'TAFFait': done,
            'N': assignmentID
          }
        ]
      }
    });

    await request.send();
  }

  Future<Account> account() async {
    final request = Request(session, 'PageInfosPerso', {
      '_Signature_': {'onglet': TabLocation.account.code}
    });

    final response = await request.send();

    return Account.fromJSON(session, response.data['donnees']);
  }
}
