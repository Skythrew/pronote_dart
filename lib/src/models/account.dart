import 'package:pronote_dart/src/models/session.dart';

class Account {
  final List<String> address;

  final String postalCode;
  final String province;
  final String country;
  final String city;

  final String email;

  /// Follows the following format: `+[country-code][phone-number]`
  final String phone;

  final String ine;

  /// Only available for PRONOTE 2024 or higher instances.
  ///
  /// iCal feature also requires to be enabled on the instance.
  final String? iCalToken;

  factory Account.fromJSON(Session session, Map<String, dynamic> json) {
    final information = json['Informations'];
    String? iCalToken;

    if (session.instance.version[0] >= 2024) {
      iCalToken = json['iCal']?['liste']['V'][0]?['paramICal'];
    }

    return Account([
      information['adresse1'],
      information['adresse2'],
      information['adresse3'],
      information['adresse4']
    ],
        information['codePostal'],
        information['province'],
        information['pays'],
        information['ville'],
        information['eMail'],
        '+${information['indicatifTel']}${information['telephonePortable']}',
        information['numeroINE'],
        iCalToken);
  }

  Account(this.address, this.postalCode, this.province, this.country, this.city,
      this.email, this.phone, this.ine, this.iCalToken);
}
