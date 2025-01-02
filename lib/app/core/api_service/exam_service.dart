import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/exam/exam.dart';
import '../../models/exam/get_exams.dart';
import '../api_config/api_config.dart';
import 'package:logger/logger.dart';

class ExamService {
  var logger = Logger();
  // Fetch all exams
  Future<List<GetExams>> fetchExams(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/exam/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      logger.d("Exams: $jsonResponse");
      if (jsonResponse['success'] == true) {
        try {
          List<GetExams> exams = (jsonResponse['exams'] as List)
              .map((examJson) => GetExams.fromJson(examJson))
              .toList();
          logger.i('Exams fetched successfully');
          return exams;
        } catch (e) {
          logger.e('Error parsing exams: $e');
          throw Exception('Error parsing exams: $e');
        }
      } else {
        logger.e('Failed to load exams');
        throw Exception('Failed to load exams');
      }
    } else {
      throw Exception('Failed to load exams');
    }
  }

  // Create a new exam
  Future<Exam> createExam(Exam exam, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/exam/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode(exam.toJson()),
    );

    if (response.statusCode == 201) {
      logger.d("Exam created successfully: ${response.body}");
      return Exam.fromJson(json.decode(response.body));
    } else {
      logger.e("Failed to create exam: ${response.body}");
      throw Exception('Failed to create exam');
    }
  }

  // Update an existing exam
  Future<Exam> updateExam(String id, Exam exam, String token) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/exam/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode(exam.toJson()),
    );

    if (response.statusCode == 200) {
      return Exam.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update exam');
    }
  }

  // Delete an exam
  Future<void> deleteExam(String id, String token) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/exam/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );
    if (response.statusCode == 200) {
      logger.i('Exam deleted successfully');
      return;
    } else {
      logger.e('Failed to delete exam');
      throw Exception('Failed to delete exam');
    }
  }
}