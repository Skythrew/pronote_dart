String cleanURL(String url) {
  Uri pronoteURI = Uri.parse(url);

  pronoteURI = Uri.https(pronoteURI.host, pronoteURI.path);

  final paths = pronoteURI.pathSegments.toList();

  if (paths.last.contains('.html')) {
    paths.removeLast();
  }

  final finalURI = Uri.https(pronoteURI.host, paths.join('/'));

  return finalURI.toString();
}
