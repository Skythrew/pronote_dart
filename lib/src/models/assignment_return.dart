import 'package:pronote_dart/src/models/attachment.dart';
import 'package:pronote_dart/src/models/enums/assignment_return_kind.dart';

class AssignmentReturn {
  final AssignmentReturnKind kind;

  /// File that the user has uploaded.
  Attachment? uploaded;

  /// Whether the user can upload a file or not.
  bool canUpload;

  AssignmentReturn(this.kind, this.uploaded, this.canUpload);
}
