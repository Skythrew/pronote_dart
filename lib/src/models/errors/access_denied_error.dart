class AccessDeniedError implements Exception {
  final String message =
      'You do not have access to this area or your authorizations are insufficient';
  AccessDeniedError();
}
