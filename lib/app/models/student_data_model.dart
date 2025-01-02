// Assuming this is in a file named student_data_model.dart
class StudentDataModel {
  final String rollNo;
  final String fullName;
  final String email;
  final String password;
  final String classId;

  StudentDataModel({
    required this.rollNo,
    required this.fullName,
    required this.email,
    required this.password,
    required this.classId,
  });

  factory StudentDataModel.fromJson(Map<String, dynamic> json) {
    return StudentDataModel(
      rollNo: json['rollNo'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      classId: json['class'],
    );
  }
}