class BusyPageError implements Exception {
  final String message = 'The site is temporarily unavailable';
  BusyPageError();
}
