import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pronote_dart/src/core/clients/base.dart';
import 'package:pronote_dart/src/models/geolocated_instance.dart';

extension PronoteBaseGeoloc on PronoteBaseClient {
  Future<List<GeolocatedInstance>> geolocation(({double lat, double lon}) position) async {
    final body = 'data={"nomFonction":"geoLoc","lat":"${position.lat}","long":"${position.lon}"}';

    final response = await http.post(
      Uri.parse('https://www.index-education.com/swie/geoloc.php'),
      headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
      },
      body: body
    );

    if (response.body == '{}') {
      return [];
    }

    final instances = jsonDecode(response.body);

    final out = List<GeolocatedInstance>.from(instances.map((el) => GeolocatedInstance.fromJSON(el, position)));

    out.sort((a, b) => a.distance > b.distance
      ? 1
      : a.distance < b.distance
        ? -1
        : a.name.compareTo(b.name) > 0
          ? 1
          : a.name.compareTo(b.name) < 0
            ? -1
            : 0
    );

    return out;
  }
}
