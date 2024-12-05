import 'package:pronote_dart/src/models/enums/account_kind.dart';
import 'package:pronote_dart/src/models/session.dart';

import 'package:pronote_dart/src/models/user_authorizations.dart';
import 'package:pronote_dart/src/models/user_resource.dart';

class UserParameters {
  final String id;
  final num kind;
  final String name;

  final UserAuthorizations authorizations;
  final List<UserResource> resources;

  factory UserParameters.fromJSON(Session session, Map<String, dynamic> json) {
    List<dynamic> resources;

    switch (session.information.accountKind) {
      case AccountKind.student:
      case AccountKind.teacher:
        resources = [json['ressource']];
        break;
      case AccountKind.parent:
        resources = json['ressource']['listeRessources'];
        break;
    }

    return UserParameters(
      json['ressource']['N'],
      json['ressource']['G'],
      json['ressource']['L'],
      UserAuthorizations.fromJSON(json['autorisations'], json['listeOnglets']),
      resources.map((el) => UserResource.fromJSON(session, el)).toList(),
    );
  }

  UserParameters(
      this.id, this.kind, this.name, this.authorizations, this.resources);
}
