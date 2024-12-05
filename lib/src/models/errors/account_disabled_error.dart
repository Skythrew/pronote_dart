class AccountDisabledError implements Exception {
  final String message = 'Your account has been deactivated';
  AccountDisabledError();
}
