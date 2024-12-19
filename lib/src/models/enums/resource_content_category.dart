enum ResourceContentCategory {
  none(0),
  lesson(1),
  correction(2),
  dst(3),
  oralInterrogation(4),
  td(5),
  tp(6),
  evaluationCompetences(7),
  epi(8),
  ap(9),
  visio(12);

  final int code;

  factory ResourceContentCategory.fromInt(int code) {
    return ResourceContentCategory.values.firstWhere((el) => el.code == code);
  }
  
  const ResourceContentCategory(this.code);
}