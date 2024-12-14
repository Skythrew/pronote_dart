import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/session.dart';
import 'package:pronote_dart/src/models/timetable.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

Future<Timetable> timetable(Session session,
    [Map<String, dynamic> additional = const {}]) async {
  final request = Request(session, 'PageEmploiDuTemps', {
    '_Signature_': {'onglet': TabLocation.timetable.code},
    'donnees': {
      'estEDTAnnuel': false,
      'estEDTPermanence': false,
      'avecAbsencesEleve': false,
      'avecRessourcesLibrePiedHoraire': false,
      'avecAbsencesRessource': true,
      'avecInfosPrefsGrille': true,
      'avecConseilDeClasse': true,
      'avecCoursSortiePeda': true,
      'avecDisponibilites': true,
      'avecRetenuesEleve': true,
      'edt': {'G': 16, 'L': 'Emploi du temps'},
      'ressource': session.userResource.encode(),
      'Ressource': session.userResource.encode(),
      ...additional
    }
  });

  final response = await request.send();

  return Timetable.fromJSON(session, response.data['donnees']);
}

Future<Timetable> timetableFromWeek(Session session, int weekNumber) async {
  return await timetable(
      session, {'numeroSemaine': weekNumber, 'NumeroSemaine': weekNumber});
}

Future<Timetable> timetableFromIntervals(
    Session session, DateTime startDate, DateTime? endDate) async {
  final endDateParam = {};

  if (endDate != null) {
    final endDateMap = {'_T': 7, 'V': encodePronoteDate(endDate)};

    endDateParam['dateFin'] = endDateMap;
    endDateParam['DateFin'] = endDateMap;
  }

  return timetable(session, {
    'dateDebut': {'_T': 7, 'V': encodePronoteDate(startDate)},
    'DateDebut': {'_T': 7, 'V': encodePronoteDate(startDate)},
    ...endDateParam
  });
}