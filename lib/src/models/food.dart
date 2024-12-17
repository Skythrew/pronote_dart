import 'dart:collection';

import 'package:pronote_dart/src/models/food_allergen.dart';
import 'package:pronote_dart/src/models/food_label.dart';

class Food {
  final String name;
  final List<FoodAllergen> allergens;
  final List<FoodLabel> labels;

  factory Food.fromJSON(Map<String, dynamic> json) {
    return Food(
      name: json['L'],
      allergens: List.unmodifiable(json['listeAllergenesAlimentaire']['V'].map((el) => FoodAllergen.fromJSON(el))),
      labels: List.unmodifiable(json['listeLabelsAlimentaires']['V'].map((el) => FoodLabel.fromJSON(el)))
    );
  }

  Food({required this.name, required this.allergens, required this.labels});
}