// lib/app/models/student/student_create.dart

class StudentCreate {
  final String rollNo;
  final String fullName;
  final String fatherName;
  final String fatherOccupation;
  final String motherName;
  final String email;
  final String phoneNumber;
  final String alternatePhoneNumber;
  final String adharNumber;
  final String dateOfBirth;
  final String gender;
  final String category;
  final String disability;
  final String typeOfInstitution;
  final String boardId;
  final String classId;
  final String password;

  StudentCreate({
    required this.rollNo,
    required this.fullName,
    required this.fatherName,
    required this.fatherOccupation,
    required this.motherName,
    required this.email,
    required this.phoneNumber,
    required this.alternatePhoneNumber,
    required this.adharNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.category,
    required this.disability,
    required this.typeOfInstitution,
    required this.boardId,
    required this.classId,
    required this.password,

  });

  // Factory method to create a StudentCreate from JSON
  factory StudentCreate.fromJson(Map<String, dynamic> json) {
    return StudentCreate(
      rollNo: json['rollNo'],
      fullName: json['fullName'],
      fatherName: json['fatherName'],
      fatherOccupation: json['fatherOccupation'],
      motherName: json['motherName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      alternatePhoneNumber: json['alternatePhoneNumber'],
      adharNumber: json['adharNumber'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      category: json['category'],
      disability: json['disability'],
      typeOfInstitution: json['typeOfInstitution'],
      boardId: json['board'],
      classId: json['class'],
      password: json['password'],
    );
  }

  // Method to convert StudentCreate to JSON
  Map<String, dynamic> toJson() {
    return {
      "rollNo": rollNo,
      "fullName": fullName,
      "fatherName": fatherName,
      "fatherOccupation": fatherOccupation,
      "motherName": motherName,
      "email": email,
      "phoneNumber": phoneNumber,
      "alternatePhoneNumber": alternatePhoneNumber,
      "adharNumber": adharNumber,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "category": category,
      "disability": disability,
      "typeOfInstitution": typeOfInstitution,
      "board": boardId,
      "class": classId,
      "password": password,
    };
  }
}