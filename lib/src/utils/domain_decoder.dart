List<int> decodeDomain(String api) {
  api = api.trim();
  if (api[0] != '[' || api[api.length - 1] != ']') return [];

  api = api.substring(1, api.length - 1);
  if (api.isEmpty) return [];

  final List<int> output = [];

  for (final part in api.split(',')) {
    if (part.contains('..')) {
      final indices = part.split('..').map((el) => int.parse(el));
      final start = indices.first;
      final end = indices.last;

      for (int index = start; index <= end; index++) {
        output.add(index);
      }
    } else {
      output.add(int.parse(part));
    }
  }

  return output;
}
