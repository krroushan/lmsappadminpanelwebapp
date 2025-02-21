import '../api_config/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/student/student_all_response.dart';
import '../../models/student/student_create.dart';
import '../../models/student/student.dart';

class StudentService {
  // Get all students with pagination
  Future<List<StudentAllResponse>> fetchStudents(int page, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/student/page/$page'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("responsemain: ${response.body}");

    if (response.statusCode == 200) {
      print("response.body: ${response.statusCode}");
      List<StudentAllResponse> studentAllResponse = [];
      studentAllResponse.add(StudentAllResponse.fromJson(jsonDecode(response.body)));
      return studentAllResponse;
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> deleteStudent(String studentId, String token) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/student/$studentId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete student');
    }
  }

  // Create a new student
    // Create a new student
  Future<void> createStudent(StudentCreate student, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/student/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(student.toJson()),
    );

    print("response: ${response.body}");

    if (response.statusCode == 201) { // Check for successful creation
      return ;
    } else {
      // Parse and print error messages
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      if (errorResponse['message'] != null || errorResponse['errors'] != null) {
        throw Exception(errorResponse['message'] ?? errorResponse['errors']); // Throw the message from the API
      } else {
        throw Exception('Failed to create student'); // Fallback message
      }
    }
  }

// Get a student by id
  Future<Student> getStudentById(String studentId, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/student/$studentId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse the outer response structure first
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // Then get the nested student object
      final studentData = responseData['student'];
      return Student.fromJson(studentData);
    } else {
      throw Exception('Failed to fetch student');
    }
  }

  // Update a student
  Future<void> updateStudent(String studentId, Map<String, dynamic> updateData, String token) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/student/$studentId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Failed to update student');
    }
  }
}


