import 'dart:convert';
import 'dart:io';

import 'package:pronote_dart/src/core/aes_helper.dart';

import 'package:pronote_dart/src/models/errors/access_denied_error.dart';
import 'package:pronote_dart/src/models/errors/page_unavailable_error.dart';
import 'package:pronote_dart/src/models/errors/rate_limited_error.dart';
import 'package:pronote_dart/src/models/errors/session_expired_error.dart';
import 'package:pronote_dart/src/models/errors/suspended_ip_error.dart';
import 'package:pronote_dart/src/models/errors/server_side_error.dart';
import 'package:pronote_dart/src/models/session.dart';

class Response {
  final Session _session;
  dynamic data;

  void _decrypt() {
    data = AESHelper.decrypt(
        data, _session.information.aesKey, _session.information.aesIV);
  }

  void _decompress() {
    data = zlib.decode(utf8.encode(data));
  }

  Response(this._session, this.data) {
    _session.information.order++;

    final content = data;

    try {
      final response = JsonDecoder().convert(content);

      if (response['Erreur'] != null) {
        final error = response['Erreur']['Titre'] ?? 'Server Error';
        throw ServerSideError(error);
      }

      data = response['donneesSec'];

      if (!_session.information.skipEncryption) {
        _decrypt();
      }

      if (!_session.information.skipCompression) {
        _decompress();
      }

      if (data is String) {
        data = JsonDecoder().convert(data);
      }

      if (data['_Signature_']?['Erreur'] != null) {
        throw ServerSideError(data['_Signature_']['MessageErreur']);
      }
    } catch (e) {
      if (content is String) {
        if (content.contains('La page a expir')) {
          throw SessionExpiredError();
        } else if (content.contains('Votre adresse IP ')) {
          throw SuspendedIpError();
        } else if (content.contains('La page dem') ||
            content.contains('Impossible d\'a')) {
          throw PageUnavailableError();
        } else if (content.contains('Vous avez d')) {
          throw RateLimitedError();
        } else if (content.contains('s refus')) {
          throw AccessDeniedError();
        }

        rethrow;
      }
    }
  }
}
