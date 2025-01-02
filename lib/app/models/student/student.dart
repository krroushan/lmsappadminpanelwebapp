import 'package:acnoo_flutter_admin_panel/app/models/board/board.dart';

import '../classes/class_info.dart'; // Import the ClassInfo model

class Student {
  final String id;
  final String fullName;
  final String fatherName;
  final String fatherOccupation;
  final String motherName;
  final String email;
  final String phoneNumber;
  final String? alternatePhoneNumber;
  final String rollNo;
  final String adharNumber;
  final String dateOfBirth;
  final String gender;
  final String category;
  final String disability;
  final String typeOfInstitution;
  final ClassInfo classInfo;
  final Board board;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.fullName,
    required this.fatherName,
    required this.fatherOccupation,
    required this.motherName,
    required this.email,
    required this.phoneNumber,
    this.alternatePhoneNumber,
    required this.rollNo,
    required this.adharNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.category,
    required this.disability,
    required this.typeOfInstitution,
    required this.classInfo,
    required this.board,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Student from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      fullName: json['fullName'],
      fatherName: json['fatherName'],
      fatherOccupation: json['fatherOccupation'],
      motherName: json['motherName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      alternatePhoneNumber: json['alternatePhoneNumber'] ?? '',
      rollNo: json['rollNo'],
      adharNumber: json['adharNumber'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      category: json['category'],
      disability: json['disability'],
      typeOfInstitution: json['typeOfInstitution'],
      classInfo: ClassInfo.fromJson(json['class']), // Use ClassInfo.fromJson
      board: Board.fromJson(json['board']), // Use Board.fromJson
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'fatherName': fatherName,
      'fatherOccupation': fatherOccupation,
      'motherName': motherName,
      'email': email,
      'phoneNumber': phoneNumber,
      'alternatePhoneNumber': alternatePhoneNumber ?? '',
      'rollNo': rollNo,
      'adharNumber': adharNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'category': category,
      'disability': disability,
      'typeOfInstitution': typeOfInstitution,
      'class': classInfo.toJson(),
      'board': board.toJson(),
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}