enum SessionAccessKind {
  account(0),
  accountConnection(1),
  directConnection(2),
  tokenAccountConnection(3),
  tokenDirectConnection(4),
  cookieConnection(5);

  final int code;

  const SessionAccessKind(this.code);
}
