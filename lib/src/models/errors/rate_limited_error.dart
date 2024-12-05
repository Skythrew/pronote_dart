class RateLimitedError implements Exception {
  final String message = 'You\'ve been rate-limited';
  RateLimitedError();
}
