import 'package:pronote_dart/src/models/enums/tab_location.dart';

class UserAuthorizations {
  /// Whether the user is allowed to read discussions.
  final bool canReadDiscussions;

  /// Whether the user is allowed to create messages in discussions.
  final bool canDiscuss;

  /// Whether the user is allowed to discuss with staff.
  final bool canDiscussWithStaff;

  /// Whether the user is allowed to discuss with parents.
  final bool canDiscussWithParents;

  /// Whether the user is allowed to discuss with students.
  final bool canDiscussWithStudents;

  /// Whether the user is allowed to discuss with teachers.
  final bool canDiscussWithTeachers;

  /// Whether the user is allowed to send HTML through discussions.
  final bool hasAdvancedDiscussionEditor;

  /// The maximum allowed file size for assignment uploads.
  final num maxAssignmentFileUploadSize;

  /// Allowed tabs for the user.
  final List<TabLocation> tabs;

  factory UserAuthorizations.fromJSON(
      Map<String, dynamic> json, List<dynamic> tabs) {
    final canReadDiscussions = json['AvecDiscussion'] ?? false;
    final canDiscuss =
        canReadDiscussions && !(json['discussionInterdit'] ?? false);
    final canDiscussWithStaff =
        canDiscuss && (json['AvecDiscussionPersonnels'] ?? false);
    final canDiscussWithParents =
        canDiscuss && (json['AvecDiscussionParents'] ?? false);
    final canDiscussWithStudents =
        canDiscuss && (json['AvecDiscussionEleves'] ?? false);
    final canDiscussWithTeachers =
        canDiscuss && (json['AvecDiscussionProfesseurs'] ?? false);

    List<TabLocation> locations = [];

    if (tabs.isNotEmpty) {
      traverse(dynamic obj) {
        if (obj['G'] != null) {
          final location = TabLocation.fromInt(obj['G']);

          if (location != null) {
            locations.add(location);
          }
        }

        if (obj['Onglet'] != null) {
          obj['Onglet'].forEach(traverse);
        }
      }

      tabs.forEach(traverse);
    }

    return UserAuthorizations(
        canReadDiscussions,
        canDiscuss,
        canDiscussWithStaff,
        canDiscussWithParents,
        canDiscussWithStudents,
        canDiscussWithTeachers,
        json['AvecDiscussionAvancee'] ?? false,
        json['tailleMaxRenduTafEleve'],
        locations);
  }

  UserAuthorizations(
      this.canReadDiscussions,
      this.canDiscuss,
      this.canDiscussWithStaff,
      this.canDiscussWithParents,
      this.canDiscussWithStudents,
      this.canDiscussWithTeachers,
      this.hasAdvancedDiscussionEditor,
      this.maxAssignmentFileUploadSize,
      this.tabs);
}
