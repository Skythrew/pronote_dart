import 'package:pronote_dart/src/models/homepage_link.dart';
import 'package:pronote_dart/src/models/partner.dart';
import 'package:pronote_dart/src/models/partner_ard.dart';

class Homepage {
  final PartnerARD? partnerARD;
  final Partner? partnerTurboself;
  final List<HomepageLink> links;

  factory Homepage.fromJSON(Map<String, dynamic> json) {
    final List<HomepageLink> links = [];

    Partner? partnerTurboself;
    PartnerARD? partnerARD;

    if (json['partenaireARD'] != null) {
      partnerARD = PartnerARD.fromJSON(json['partenaireARD']);
    }

    for (final link in json['lienUtile']['listeLiens']['V']) {
      if (link['SSO'] != null) {
        if (link['SSO']['codePartenaire'] == 'TURBOSELF') {
          partnerTurboself = Partner.fromJSON(link);
        }
      } else {
        links.add(HomepageLink.fromJSON(link));
      }
    }

    return Homepage(
      partnerARD: partnerARD,
      partnerTurboself: partnerTurboself,
      links: links
    );
  }

  Homepage({required this.partnerARD, required this.partnerTurboself, required this.links});
}