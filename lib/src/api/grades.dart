import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/evaluation.dart';
import 'package:pronote_dart/src/models/grades_overview.dart';
import 'package:pronote_dart/src/models/period.dart';
import 'package:pronote_dart/src/models/session.dart';

/// Gets grades overview for a specific period.
/// Including student's grades with averages and the global averages.
Future<GradesOverview> gradesOverview(Session session, Period period) async {
  final request = Request(session, 'DernieresNotes', {
    '_Signature_': {'onglet': TabLocation.grades.code},
    'donnees': {'Periode': period.encode()}
  });

  final response = await request.send();

  return GradesOverview.fromJSON(session, response.data['donnees']);
}

Future<String> gradeReportPDF(Session session, Period period) async {
  final request = Request(session, 'GenerationPDF', {
    'donnees': {
      'avecCodeCompetences': false,
      'genreGenerationPDF': 2,
      'options': {
        'adapterHauteurService': false,
        'desEleves': false,
        'gererRectoVerso': false,
        'hauteurServiceMax': 15,
        'hauteurServiceMin': 10,
        'piedMonobloc': true,
        'portrait': true,
        'taillePolice': 6.5,
        'taillePoliceMin': 5,
        'taillePolicePied': 6.5,
        'taillePolicePiedMin': 5
      },
      'periode': period.encode()
    },
    '_Signature_': {'onglet': TabLocation.gradebook.code}
  });

  final response = await request.send();
  return '${session.information.url}/${Uri.encodeComponent(response.data['donnees']['url']['V'])}';
}


Future<List<Evaluation>> evaluations(Session session, Period period) async {
  final request = Request(session, 'DernieresEvaluations', {
    '_Signature_': {
      'onglet': TabLocation.evaluations.code
    },

    'donnees': {
      'periode': period.encode()
    }
  });

  final response = await request.send();

  return List<Evaluation>.from(response.data['donnees']['listeEvaluations']['V'].map((el) => Evaluation.fromJSON(el)));
}
