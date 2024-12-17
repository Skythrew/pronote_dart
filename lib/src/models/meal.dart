import 'package:pronote_dart/src/models/enums/dish_kind.dart';
import 'package:pronote_dart/src/models/food.dart';

class Meal {
  final String? name;
  final List<Food>? entry;
  final List<Food>? main;
  final List<Food>? side;
  final List<Food>? drink;
  final List<Food>? fromage;
  final List<Food>? dessert;

  factory Meal.fromJSON(Map<String, dynamic> json) {
    List<Food>? entry;
    List<Food>? main;
    List<Food>? side;
    List<Food>? drink;
    List<Food>? fromage;
    List<Food>? dessert;

    json['ListePlats']['V'].forEach((dish) {
      final dishes = List<Food>.from(dish['ListeAliments']['V'].map((el) => Food.fromJSON(el)));

      switch (DishKind.fromInt(dish['G'])) {
        case DishKind.entry:
          entry = dishes;
          break;
        case DishKind.main:
          main = dishes;
          break;
        case DishKind.side:
          side = dishes;
          break;
        case DishKind.drink:
          drink = dishes;
          break;
        case DishKind.fromage:
          fromage = dishes;
          break;
        case DishKind.dessert:
          dessert = dishes;
          break;          
      }
    });

    return Meal(
      name: json['L'],
      entry: entry,
      main: main,
      side: side,
      drink: drink,
      fromage: fromage,
      dessert: dessert
    );
  }

  Meal({required this.name, required this.entry, required this.main, required this.side, required this.drink, required this.fromage, required this.dessert});
}