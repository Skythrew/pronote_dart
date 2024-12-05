enum AttachmentKind {
  link(0),
  file(1);

  final int code;

  factory AttachmentKind.fromInt(int code) {
    return AttachmentKind.values.firstWhere((el) => el.code == code);
  }

  const AttachmentKind(this.code);
}
