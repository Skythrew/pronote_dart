class Partner {
  /// Object to send to PRONOTE to login using SSO.
  final dynamic sso;

  factory Partner.fromJSON(Map<String, dynamic> json) {
    return Partner(sso: json['SSO']);
  }

  Partner({required this.sso});
}