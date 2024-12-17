
import 'package:pronote_dart/src/models/instance_account.dart';

class Instance {
  final List<int> version;
  final String name;
  final DateTime date;

  final List<InstanceAccount> accounts;

  final String? casURL;
  final String? casToken;

  factory Instance.fromJSON(Map<String, dynamic> json) {
    String? casURL;
    String? casToken;

    if (json['CAS']['actif']) {
      casURL = json['CAS']['casURL'];
      casToken = json['CAS']['jetonCAS'];
    }

    return Instance(
      name: json['nomEtab'],
      version: List<int>.from(json['version']),
      date: DateTime.parse(json['date']),
      accounts: List<InstanceAccount>.from(json['espaces'].map((el) => InstanceAccount.fromJSON(el))),
      casURL: casURL,
      casToken: casToken
    );
  }

  Instance({required this.version, required this.name, required this.date, required this.accounts, required this.casURL, required this.casToken});
}