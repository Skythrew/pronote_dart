enum EntityState {
  none(0),
  creation(1),
  modification(2),
  deletion(3),
  childrenModification(4);

  final int code;

  const EntityState(this.code);
}