import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:hex/hex.dart';
import 'package:pronote_dart/src/core/response.dart';
import 'package:pronote_dart/src/core/aes_helper.dart';
import 'package:pronote_dart/src/models/session.dart';

class ReqPayload {
  final String order;
  final Uri url;

  ReqPayload(this.order, this.url);
}

class Request {
  final Session session;

  /// Function name.
  ///
  /// This is used by the server to determine
  /// the function to call.
  final String name;

  /// Data given to the "secure" property.
  dynamic data;

  ReqPayload _process() {
    session.information.order++;

    final order = _generateOrder();
    final url = Uri.parse(
        '${session.information.url}/appelfonction/${session.information.accountKind.code}/${session.information.id}/$order');

    if (!session.information.skipCompression) {
      _compress();
    }

    if (!session.information.skipEncryption) {
      _encrypt();
    }

    return ReqPayload(order, url);
  }

  String _generateOrder() {
    return AESHelper.encrypt(
        utf8.encode(session.information.order.toString()),
        session.information.aesKey,
        session.information.aesIV,
        session.information.order == 1);
  }

  String _stringify() {
    return JsonEncoder().convert(data);
  }

  void _compress() {
    final buffer = utf8.encode(_stringify());

    final deflated = zlib.encode(buffer);
    data = HEX.encode(deflated);
  }

  void _encrypt() {
    data = AESHelper.encrypt(data, session.information.aesKey,
        session.information.aesIV, session.information.order == 1);
  }

  Future<Response> send() async {
    final payload = _process();

    final response = await http.post(payload.url,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0'
        },
        body: JsonEncoder().convert({
          'session': session.information.id,
          'numeroOrdre': payload.order,
          'nom': name,
          'donneesSec': data
        }));

    return Response(session, response.body);
  }

  Request(this.session, this.name, this.data);
}
