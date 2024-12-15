import 'package:pronote_dart/src/models/skill.dart';
import 'package:pronote_dart/src/models/subject.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

class Evaluation {
  final String name;
  final String id;
  final String teacher;
  final num coefficient;
  final String description;
  final Subject subject;
  /// Example: `["Cycle 4"]`
  final List<String> levels;
  final List<Skill> skills;
  final DateTime date;

  factory Evaluation.fromJSON(Map<String, dynamic> json) {
    final List<Skill> skills = List<Skill>.from(json['listeNiveauxDAcquisitions']['V'].map((el) => Skill.fromJSON(el)));
    skills.sort((a, b) => a.order - b.order);

    return Evaluation(
      json['L'],
      json['N'],
      json['individu']['V']['L'],
      json['coefficient'],
      json['descriptif'],
      Subject.fromJSON(json['matiere']['V']),
      List<String>.from(json['listePaliers']['V'].map((el) => el['L'])),
      skills,
      decodePronoteDate(json['date']['V'])
    );
  }

  Evaluation(this.name, this.id, this.teacher, this.coefficient, this.description, this.subject, this.levels, this.skills, this.date);
}