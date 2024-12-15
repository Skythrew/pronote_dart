enum DocumentKind {
  url(0),
  file(1),
  cloud(2),
  kioskLink(3),
  conferenceLink(4);

  final int code;

  const DocumentKind(this.code);
}