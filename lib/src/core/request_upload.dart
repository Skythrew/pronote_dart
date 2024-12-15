import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pronote_dart/src/core/aes_helper.dart';
import 'package:pronote_dart/src/models/session.dart';

class RequestUpload {
  late String order;
  late final Session session;
  final String id = 'selecfile_1_${DateTime.now()}';

  late final http.MultipartRequest _request;

  RequestUpload(
    this.session,
    String functionName,
    http.MultipartFile file,
    String fileName
  ) {
    session.information.order++;

    final aesKey = session.information.aesKey;
    final aesIV = session.information.aesIV;

    order = AESHelper.encrypt(utf8.encode(session.information.order.toString()), aesKey, aesIV, false);

    final request = http.MultipartRequest('POST',
      Uri.parse('${session.information.url}/uploadfilesession/${session.information.accountKind}/${session.information.id}'));

    request.fields['numeroOrdre'] = order;
    request.fields['numeroSession'] = session.information.id.toString();
    request.fields['nomRequete'] = functionName;
    request.fields['idFichier'] = id;
    request.fields['md5'] = '';

    request.files.add(file);
  
    request.headers['Content-Disposition'] = 'attachment; filename="${Uri.encodeComponent(fileName)}"';
    
    _request = request;
  }

  Future<void> send() async {
    int state = 3;

    while (state == 3) {
      final response = await _request.send();

      final json = jsonDecode(await response.stream.bytesToString());
      state = json['etat'];
    }

    session.information.order++;

    if (state == 0 || state == 2) {
      throw 'File upload failed';
    }
  }
}