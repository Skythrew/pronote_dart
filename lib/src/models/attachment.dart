import 'dart:convert';

import 'package:pronote_dart/src/core/aes_helper.dart';
import 'package:pronote_dart/src/models/session.dart';

import 'package:pronote_dart/src/models/enums/attachment_kind.dart';

class Attachment {
  final AttachmentKind kind;
  final String name;
  final String url;
  final String id;

  factory Attachment.fromJSON(Session session, Map<String, dynamic> json,
      [Map<String, dynamic> params = const {}]) {
    final String name = json['L'] ?? '';
    final int kind = json['G'];
    final String id = json['N'];

    String url;

    if (kind == AttachmentKind.link.code) {
      url = json['url'] ?? name;
    } else {
      final key = session.information.aesKey;
      final iv = session.information.aesIV;

      final data = jsonEncode({'N': id, 'Actif': true, ...params});

      final encrypted = AESHelper.encrypt(utf8.encode(data), key, iv, false);
      url =
          '${session.information.url}/FichiersExternes/$encrypted/${Uri.encodeComponent(name)}?Session=${session.information.id}';
    }

    return Attachment(AttachmentKind.fromInt(kind), name, url, id);
  }

  Attachment(this.kind, this.name, this.url, this.id);
}
