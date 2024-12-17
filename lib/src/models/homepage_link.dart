class HomepageLink {
  final String url;
  final String name;
  final String description;

  factory HomepageLink.fromJSON(Map<String, dynamic> json) {
    return HomepageLink(
      url: json['url'],
      name: json['L'],
      description: json['commentaire']
    );
  }

  HomepageLink({required this.url, required this.name, required this.description});
}