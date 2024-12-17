enum MealKind {
  lunch(0),
  dinner(1);

  final int code;

  factory MealKind.fromInt(int code) {
    return MealKind.values.firstWhere((el) => el.code == code);
  }

  const MealKind(this.code);
}