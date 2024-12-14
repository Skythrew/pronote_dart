class Subject {
  final String id;
  final String name;

  /// Whether the subject is only within groups.
  final bool inGroups;

  factory Subject.fromJSON(Map<String, dynamic> json) {
    return Subject(json['N'], json['L'], json['estServiceGroupe'] ?? false);
  }

  Subject(this.id, this.name, this.inGroups);
}
