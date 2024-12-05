import 'package:pronote_dart/src/models/enums/account_kind.dart';

String encodeAccountKindToPath(AccountKind kind) {
  String name;

  switch (kind) {
    case AccountKind.student:
      name = 'eleve';
      break;
    case AccountKind.parent:
      name = 'parent';
      break;
    case AccountKind.teacher:
      name = 'professeur';
      break;
  }

  return 'mobile.$name.html';
}
