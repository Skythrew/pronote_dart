import 'package:pronote_dart/src/utils/haversine.dart';

class GeolocatedInstance {
  final String url;
  final String name;
  final double latitude;
  final double longitude;
  final int postalCode;
  final double distance;

  factory GeolocatedInstance.fromJSON(Map<String, dynamic> json, ({double lat, double lon}) position) {
    final latitude = double.parse(json['lat']);
    final longitude = double.parse(json['long']);

    final ({double lat, double lon}) instancePos = (lat: latitude, lon: longitude);

    return GeolocatedInstance(
      json['url'].toLowerCase(),
      json['nomEtab']
        .trim()
        .replaceAll('COLLEGE', 'COLLÈGE')
        .replaceAll('LYCEE', 'LYCÉE'),
      latitude,
      longitude,
      int.parse(json['cp']),
      haversine(position, instancePos)
    );
  }

  GeolocatedInstance(this.url, this.name, this.latitude, this.longitude, this.postalCode, this.distance);
}