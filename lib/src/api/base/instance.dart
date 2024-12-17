import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pronote_dart/src/core/clients/base.dart';
import 'package:pronote_dart/src/models/instance.dart';
import 'package:pronote_dart/src/utils/clean_url.dart';

extension PronoteBaseInstance on PronoteBaseClient {
  Future<Instance> instance(String url) async {
    url = cleanURL(url);
    url += '/infoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4';

    final response = await http.get(Uri.parse(url));
    final instance = jsonDecode(response.body);
    return Instance.fromJSON(instance);
  }
}