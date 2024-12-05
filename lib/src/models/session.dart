import 'package:pronote_dart/src/models/user_resource.dart';
import 'package:pronote_dart/src/models/user_parameters.dart';
import 'package:pronote_dart/src/models/instance_parameters.dart';
import 'package:pronote_dart/src/models/session_information.dart';

class Session {
  /// Equivalent of a PRONOTE session.
  /// Contains metadata and more.
  late final SessionInformation information;
  late final InstanceParameters instance;
  late final UserParameters user;
  late final UserResource userResource;
}
