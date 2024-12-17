class FoodLabel {
  final String name;

  /// As a hexadecimal color.
  final String color;

  factory FoodLabel.fromJSON(Map<String, dynamic> json) {
    return FoodLabel(
      name: json['L'],
      color: json['couleur']
    );
  }

  FoodLabel({required this.name, required this.color});
}