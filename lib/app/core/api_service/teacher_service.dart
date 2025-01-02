// 🐦 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// 🌎 Project imports:
import '../api_config/api_config.dart';
import '../../models/teacher/teacher.dart';
import '../../models/teacher/teacher_create.dart';

class TeacherService {
  var logger = Logger();

  //get all teachers
  // Future<List<Teacher>> fetchTeachers() async {
  //   final response = await http.get(
  //     Uri.parse('${ApiConfig.baseUrl}/teacher/all'),
  //     headers: {
  //       'Authorization': 'Bearer ${ApiConfig.token}',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     // Decode the response body as a list and map to List<Teacher>
  //     List<Teacher> teacherList = [];
  //     teacherList.add(Teacher.fromJson(jsonDecode(response.body)));
  //     logger.i('Teachers fetched successfully');
  //     return teacherList;
  //   } else {
  //     logger.e('Failed to load teachers');
  //     throw Exception('Failed to load teachers');
  //   }
  // }

  Future<List<Teacher>> fetchAllTeachers(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/teacher/all'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        List<Teacher> teachers = (jsonResponse['teachers'] as List)
            .map((teacherJson) => Teacher.fromJson(teacherJson))
            .toList();
        logger.i('Teachers fetched successfully');
        return teachers;
      } else {
        logger.e('Failed to load teachers');
        throw Exception('Failed to load teachers');
      }
    } else {
      logger.e('Failed to load teachers: ${response.statusCode}');
      throw Exception('Failed to load teachers: ${response.statusCode}');
    }
  }

  //delete teacher
  Future<void> deleteTeacher(String teacherId, String token) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/teacher/$teacherId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      logger.i('Teacher deleted successfully');
      return;
    } else {
      logger.e('Failed to delete teacher');
      throw Exception('Failed to delete teacher');
    }
  }

//create teacher
  Future<void> createTeacher(TeacherCreate teacher, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/teacher/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(teacher.toJson()),
    );

    logger.i("response: ${response.body}");

    if (response.statusCode == 201) { 
      logger.i('Teacher created successfully');
      return;
    } else {
      // Parse and print error messages
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      if (errorResponse['message'] != null || errorResponse['errors'] != null) {
        logger.e(errorResponse['message'] ?? errorResponse['errors']); 
        throw Exception(errorResponse['message'] ?? errorResponse['errors']); 
      } else {
        logger.e('Failed to create teacher');
        throw Exception('Failed to create teacher'); 
      }
    }
  }
}
