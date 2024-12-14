enum GradeKind {
  error(-1),
  grade(0),
  absent(1),
  exempted(2),
  notGraded(3),
  unfit(4),
  unreturned(5),
  absentZero(6),
  unreturnedZero(7),
  congratulations(8);

  final int code;

  factory GradeKind.fromInt(int code) {
    return GradeKind.values.firstWhere((el) => el.code == code);
  }

  const GradeKind(this.code);
}
