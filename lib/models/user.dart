import 'dart:convert';

class User{
  final String name;
  final Role role;
  final SignLanguageType signLanguageType;

  User({
    required this.name,
    required this.role,
    required this.signLanguageType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      role: Role.values[json['role']],
      signLanguageType: SignLanguageType.values[json['signLanguageType']],
    );
  }

  String toJson() {
    return jsonEncode({
      'name': name,
      'role': role.index,
      'signLanguageType': signLanguageType.index,
    });
  }
}

enum Role {
  deaf,
  hearing,
}

enum SignLanguageType {
  asl,
}