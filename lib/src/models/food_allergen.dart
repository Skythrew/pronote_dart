class FoodAllergen {
  final String name;

  /// As a hexadecimal color.
  final String color;

  factory FoodAllergen.fromJSON(Map<String, dynamic> json) {
    return FoodAllergen(
      name: json['L'],
      color: json['couleur']
    );
  }

  FoodAllergen({required this.name, required this.color});
}