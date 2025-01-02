class Teacher {
  final String id;
  final String username;
  final String fullName;
  final String role;
  final String password; // Consider handling passwords securely
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  Teacher({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.password,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['_id'],
      username: json['username'],
      fullName: json['fullName'],
      role: json['role'],
      password: json['password'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'fullName': fullName,
      'role': role,
      'password': password,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}