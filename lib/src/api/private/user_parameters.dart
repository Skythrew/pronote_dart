import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/user_parameters.dart';

Future<UserParameters> userParameters(Session session) async {
  final request = Request(session, 'ParametresUtilisateur', {});
  final response = await request.send();
  return UserParameters.fromJSON(session, response.data['donnees']);
}
