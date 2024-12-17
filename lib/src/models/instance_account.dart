class InstanceAccount {
  final String name;
  final String path;

  factory InstanceAccount.fromJSON(Map<String, dynamic> json) {
    return InstanceAccount(
      name: json['nom'],
      path: json['URL']
    );
  }

  InstanceAccount({required this.name, required this.path});
}