import 'package:pronote_dart/src/models/food_allergen.dart';
import 'package:pronote_dart/src/models/food_label.dart';
import 'package:pronote_dart/src/models/menu.dart';
import 'package:pronote_dart/src/utils/domain_decoder.dart';

class WeekMenu {
  final bool containsLunch;
  final bool containsDinner;

  /// Menu for each day of the week.
  final List<Menu> days;

  /// Week numbers that are available
  /// for the menu.
  final List<int> weeks;

  final List<FoodAllergen> allergens;
  final List<FoodLabel> labels;

  factory WeekMenu.fromJSON(Map<String, dynamic> json) {
    return WeekMenu(
      containsLunch: json['AvecRepasMidi'],
      containsDinner: json['AvecRepasSoir'],
      days: List<Menu>.from(json['ListeJours']['V'].map((el) => Menu.fromJSON(el))),
      weeks: decodeDomain(json['DomaineDePresence']['V']),
      allergens: List<FoodAllergen>.from(json['ListeAllergenes']['V'].map((el) => FoodAllergen.fromJSON(el))),
      labels: List<FoodLabel>.from(json['Listelabels']['V'].map((el) => FoodLabel.fromJSON(el)))
    );
  }

  WeekMenu({required this.containsLunch, required this.containsDinner, required this.days, required this.weeks, required this.allergens, required this.labels});
}