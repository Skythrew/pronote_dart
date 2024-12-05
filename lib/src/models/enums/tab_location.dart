enum TabLocation {
  grades(198),
  resources(89),
  assignments(88),
  timetable(16),
  evaluations(201),
  account(49),
  presence(7),
  news(8),
  notebook(19),
  discussions(131),
  gradebook(13),
  menus(10);

  final int code;

  static TabLocation? fromInt(int code) {
    for (final tabLocation in TabLocation.values) {
      if (tabLocation.code == code) {
        return tabLocation;
      }
    }

    return null;
  }

  const TabLocation(this.code);
}
