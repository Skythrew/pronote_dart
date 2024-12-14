class TimetableClassActivity {
  final String title;
  final List<String> attendants;
  final String resourceTypeName;
  final String resourceValue;

  factory TimetableClassActivity.fromJSON(Map<String, dynamic> json) {
    return TimetableClassActivity(json['motif'], json['accompagnateurs'],
        json['strGenreRess'], json['strRess']);
  }

  TimetableClassActivity(
      this.title, this.attendants, this.resourceTypeName, this.resourceValue);
}
