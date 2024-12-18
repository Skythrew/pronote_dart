enum EstablishmentAccessKind {
  boardingSchool(0),
  school(1),
  halfBoard(2);

  final int code;

  factory EstablishmentAccessKind.fromInt(int code) {
    return EstablishmentAccessKind.values.firstWhere((el) => el.code == code);
  }
  
  const EstablishmentAccessKind(this.code);
}