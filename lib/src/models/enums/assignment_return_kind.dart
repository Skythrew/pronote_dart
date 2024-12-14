enum AssignmentReturnKind {
  none(0),
  paper(1),
  fileUpload(2),
  kiosk(3),

  // Only available since version 2024.
  audioRecording(4);

  final int code;

  factory AssignmentReturnKind.fromInt(int code) {
    return AssignmentReturnKind.values.firstWhere((el) => el.code == code);
  }

  const AssignmentReturnKind(this.code);
}
