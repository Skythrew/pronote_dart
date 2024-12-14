import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:pronote_dart/src/models/enums/account_kind.dart';
import 'package:pronote_dart/src/models/errors/busy_page_error.dart';
import 'package:pronote_dart/src/models/errors/page_unavailable_error.dart';
import 'package:pronote_dart/src/models/errors/suspended_ip_error.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/session_information.dart';

Future<SessionInformation> sessionInformation(Session session, String base,
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
