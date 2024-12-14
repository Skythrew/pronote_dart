enum AccountKind {
  student(6),
  parent(7),
  teacher(8);

  final int code;

  factory AccountKind.fromInt(int code) {
    return AccountKind.values.firstWhere((el) => el.code == code);
  }

  String encodeToPath() {
    String name;

    switch (this) {
      case AccountKind.student:
        name = 'eleve';
        break;
      case AccountKind.parent:
        name = 'parent';
        break;
      case AccountKind.teacher:
        name = 'professeur';
        break;
    }

    return 'mobile.$name.html';
  }

  const AccountKind(this.code);
}
