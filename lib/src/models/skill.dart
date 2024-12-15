class Skill {
  final String id;
  
  /// Order the skill should be shown.
  /// For example, if this value is `2`, then it should be shown
  /// as the second skill.
  final int order;

  /// Example: "Très bonne maîtrise"
  final String level;

  /// Example: "A+"
  final String abreviation;

  final num coefficient;

  /// ID of the domain tree containing this skill.
  final String domainID;

  /// Name of the domain tree.
  final String domainName;

  /// ID of the skill's item.
  final String? itemID;

  /// Name of the skill's item.
  final String? itemName;

  /// Skill's pillar ID.
  final String pillarID;

  /// Skill's pillar name.
  final String pillarName;

  /// Example: `["D1.2", "D2"]`
  final List<String> pillarPrefixes;

  factory Skill.fromJSON(Map<String, dynamic> json) {
    return Skill(
      json['N'],
      json['ordre'],
      json['L'],
      json['abbreviation'],
      json['coefficient'],
      json['domaine']['V']['N'],
      json['domaine']['V']['L'],
      json['item']?['V']['N'],
      json['item']?['V']['L'],
      json['pilier']['V']['N'],
      json['pilier']['V']['L'],
      List<String>.from(json['pilier']['V']['strPrefixes'].split(',').map((el) => el.trim()))
    );
  }

  Skill(this.id, this.order, this.level, this.abreviation, this.coefficient, this.domainID, this.domainName, this.itemID, this.itemName, this.pillarID, this.pillarName, this.pillarPrefixes);
}