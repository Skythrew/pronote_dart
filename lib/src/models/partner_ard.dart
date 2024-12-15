import 'package:pronote_dart/src/models/partner.dart';

class PartnerARDWallet {
  final String name;
  final String description;
  final bool warning;
  final num balance;
  final String balanceDescription;

  factory PartnerARDWallet.fromJSON(Map<String, dynamic> json) {
    return PartnerARDWallet(
      name: json['libellePorteMonnaie'],
      description: json['hintPorteMonnaie'],
      warning: json['avecWarning'],
      balance: num.parse(json['valeurSolde'].replace(',', '.')),
      balanceDescription: json['hintSolde']
    );
  }

  PartnerARDWallet({required this.name, required this.description, required this.warning, required this.balance, required this.balanceDescription});
}

class PartnerARD extends Partner {
  final bool canRefreshData;
  final List<PartnerARDWallet> wallets;

  factory PartnerARD.fromJSON(Map<String, dynamic> json) {
    return PartnerARD(
      sso: json['SSO'],
      canRefreshData: json['avecActualisation'],
      wallets: json['porteMonnaie']['V'].map((el) => PartnerARD.fromJSON(el))
    );
  }

  PartnerARD({required super.sso, required this.canRefreshData, required this.wallets});
}