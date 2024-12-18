enum NotebookObservationKind {
  logBookIssue(0),
  observation(1),
  encouragement(2),
  other(3);

  final int code;

  factory NotebookObservationKind.fromInt(int code) {
    return NotebookObservationKind.values.firstWhere((el) => el.code == code);
  }
  
  const NotebookObservationKind(this.code);
}