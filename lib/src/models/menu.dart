import 'package:pronote_dart/src/models/enums/meal_kind.dart';
import 'package:pronote_dart/src/models/meal.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

class Menu {
  final DateTime date;
  final Meal? lunch;
  final Meal? dinner;

  factory Menu.fromJSON(Map<String, dynamic> json) {
    Meal? lunch;
    Meal? dinner;

    json['ListeRepas']['V'].forEach((meal) {
      final Meal mealObj = Meal.fromJSON(meal);

      switch (MealKind.fromInt(meal['G'])) {
        case MealKind.lunch:
          lunch = mealObj;
          break;
        case MealKind.dinner:
          dinner = mealObj;
          break;
      }
    });

    return Menu(
      date: decodePronoteDate(json['Date']['V']),
      lunch: lunch,
      dinner: dinner
    );
  }

  Menu({required this.date, required this.lunch, required this.dinner});
}