class SessionExpiredError implements Exception {
  final String message = 'Session has expired';
  SessionExpiredError();
}
