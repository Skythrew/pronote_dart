import 'dart:math';

const earthRadius = 6378137;

num squared (num x) { return x * x; }
num toRad   (num x) { return x * pi / 180; }
num hav     (num x) { return squared(sin(x / 2)); }

double haversine (({num lat, num lon}) a, ({num lat, num lon}) b) {
  final aLat = toRad(a.lat);
  final bLat = toRad(b.lat);

  final aLng = toRad(a.lon);
  final bLng = toRad(b.lon);

  final ht = hav(bLat - aLat) + cos(aLat) * cos(bLat) * hav(bLng - aLng);

  return 2 * earthRadius * asin(sqrt(ht));
}