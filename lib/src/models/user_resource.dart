import 'package:pronote_dart/src/models/session.dart';

import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/tab.dart';
import 'package:pronote_dart/src/models/attachment.dart';

class UserResource {
  final String id;
  final num kind;
  final String name;
  final String? className;
  final String establishmentName;
  final Attachment? profilePicture;
  final bool isDirector;
  final bool isDelegate;
  final bool isMemberCA;
  final Map<TabLocation, Tab> tabs;

  factory UserResource.fromJSON(Session session, Map<String, dynamic> json) {
    Attachment? profilePicture;

    if (json['avecPhoto']) {
      profilePicture = Attachment.fromJSON(
          session, {'G': 1, 'N': json['N'], 'L': 'photo.jpg'});
    }

    Map<TabLocation, Tab> tabs = {};

    for (final tab in json['listeOngletsPourPeriodes']?['V'] ?? []) {
      final location = TabLocation.fromInt(tab['G']);

      if (location != null) {
        tabs[location] = Tab.fromJSON(tab, session.instance.periods);
      }
    }

    return UserResource(
        json['N'],
        json['G'],
        json['L'],
        json['classeDEleve']?['L'],
        json['Etablissement']['V']['L'],
        profilePicture,
        json['estDirecteur'] ?? false,
        json['estDelegue'] ?? false,
        json['estMembreCA'] ?? false,
        tabs);
  }

  Map<String, dynamic> encode() {
    return {'G': kind, 'L': name, 'N': id};
  }

  UserResource(
      this.id,
      this.kind,
      this.name,
      this.className,
      this.establishmentName,
      this.profilePicture,
      this.isDirector,
      this.isDelegate,
      this.isMemberCA,
      this.tabs);
}
