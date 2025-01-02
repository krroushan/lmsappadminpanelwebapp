class AdminCreate {
  final String username;
  final String fullName;
  final String password; // Consider handling passwords securely
  final String email;

  AdminCreate({
    required this.username,
    required this.fullName,
    required this.password,
    required this.email,
  });

  factory AdminCreate.fromJson(Map<String, dynamic> json) {
    return AdminCreate(
      username: json['username'],
      fullName: json['fullName'],
      password: json['password'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'password': password,
      'email': email,
    };
  }
}