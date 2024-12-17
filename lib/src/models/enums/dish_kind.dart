enum DishKind {
  entry(0),
  main(1),
  side(2),
  drink(3),
  dessert(4),
  fromage(5);

  final int code;

  factory DishKind.fromInt(int code) {
    return DishKind.values.firstWhere((el) => el.code == code);
  }
  
  const DishKind(this.code);
}