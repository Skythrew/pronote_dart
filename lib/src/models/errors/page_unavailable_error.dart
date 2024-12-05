class PageUnavailableError implements Exception {
  final String message = 'The requested page does not exist';
  PageUnavailableError();
}
