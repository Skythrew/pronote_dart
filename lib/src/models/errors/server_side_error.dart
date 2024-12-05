class ServerSideError implements Exception {
  final String cause;
  ServerSideError(this.cause);
}
