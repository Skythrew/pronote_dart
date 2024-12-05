class BadCredentialsError implements Exception {
  final String message =
      'Unable to resolve the challenge, make sure the credentials are correct.';
  BadCredentialsError();
}
