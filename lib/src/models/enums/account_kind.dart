enum AccountKind {
  student(6),
  parent(7),
  teacher(8);

  final int code;

  factory AccountKind.fromInt(int code) {
    return AccountKind.values.firstWhere((el) => el.code == code);
  }

  const AccountKind(this.code);
}
