class TimetableClassDetention {
  final String? title;
  final List<String> personalNames;
  final List<String> teacherNames;
  final List<String> classrooms;

  factory TimetableClassDetention.fromJSON(Map<String, dynamic> json) {
    String? title;

    final List<String> personalNames = [];
    final List<String> teacherNames = [];
    final List<String> classrooms = [];

    if (json['ListeContenus'] != null) {
      for (final data in json['ListeContenus']['V']) {
        final label = data['L'];

        if (data['estHoraire'] != null && data['estHoraire']) {
          title = label;
        } else if (data['G'] != null) {
          switch (data['G']) {
            case 3:
              teacherNames.add(label);
              break;
            case 34:
              personalNames.add(label);
              break;
            case 17:
              classrooms.add(label);
              break;
          }
        }
      }
    }

    return TimetableClassDetention(
        title, personalNames, teacherNames, classrooms);
  }

  TimetableClassDetention(
      this.title, this.personalNames, this.teacherNames, this.classrooms);
}
