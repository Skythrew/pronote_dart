enum AssignmentDifficulty {
  none(0),
  easy(1),
  medium(2),
  hard(3);

  final int code;

  factory AssignmentDifficulty.fromInt(int code) {
    return AssignmentDifficulty.values.firstWhere((el) => el.code == code);
  }

  const AssignmentDifficulty(this.code);
}
