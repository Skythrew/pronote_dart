import 'package:pronote_dart/src/models/assignment_theme.dart';
import 'package:pronote_dart/src/models/attachment.dart';
import 'package:pronote_dart/src/models/enums/resource_content_category.dart';
import 'package:pronote_dart/src/models/session.dart';

class ResourceContent {
  final String id;

  /// Optional because teachers can just write nothing here.
  final String? title;

  /// An HTML string to preserve all the formatting done in the UI.
  /// Optional because teachers can just write the title without any description.
  final String? description;

  final ResourceContentCategory category;
  final List<Attachment> files;
  /// Themes associated with the lesson.
  final List<AssignmentTheme> themes;

  /// `-1` when not defined.
  final int educativeValue;

  factory ResourceContent.fromJSON(Session session, Map<String, dynamic> json) {
    return ResourceContent(
      id: json['N'],
      title: json['L'],
      description: json['descriptif']?['V'],
      category: ResourceContentCategory.fromInt(json['categorie']['V']['G']),
      files: List<Attachment>.from(json['ListePieceJointe']['V'].map((el) => Attachment.fromJSON(session, el))),
      themes: List<AssignmentTheme>.from(json['ListeThemes']['V'].map((el) => AssignmentTheme.fromJSON(el))),
      educativeValue: json['parcoursEducatif']
    );
  }

  ResourceContent({required this.id, required this.title, required this.description, required this.category, required this.files, required this.themes, required this.educativeValue});
}