import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/exam/exam.dart';
import '../api_config/api_config.dart';
import 'package:logger/logger.dart';
import '../../models/exam/get_exam.dart';

class ExamService {
  static var logger = Logger();
  // Create a new exam
  Future<void> createExam(Exam exam, String token) async {
    logger.d('Creating exam with data: ${exam.toJson()}');
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/exam/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode(exam.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      logger.d("Exam creation response: ${response.body}");
      
      if (jsonResponse['success'] == true) {
          return;
      } else {
        logger.e("Failed to create exam: ${jsonResponse['message']}");
        throw Exception(jsonResponse['message'] ?? 'Failed to create exam');
      }
    } else {
      logger.e("Failed to create exam: ${response.body}");
      throw Exception('Failed to create exam');
    }
  }

  // Update an existing exam
  Future<void> updateExam(String id, Map<String, dynamic> exam, String token) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/exam/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode(exam),
    );

    if (response.statusCode == 200) {
      return;
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

  // Fetch all exams
  Future<List<GetExam>> getAllExams(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/exam/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      logger.d("Exams fetch response: ${response.body}");
      
      if (jsonResponse['success'] == true) {
        final List<dynamic> examsList = jsonResponse['exams'];
        return examsList.map((json) => GetExam.fromJson(json)).toList();
      } else {
        logger.e("Failed to fetch exams: ${jsonResponse['message']}");
        throw Exception(jsonResponse['message'] ?? 'Failed to fetch exams');
      }
    } else {
      logger.e("Failed to fetch exams: ${response.body}");
      throw Exception('Failed to fetch exams');
    }
  }

  // Get exam by ID
  static Future<GetExam> getExamById(String examId, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/exam/$examId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      logger.d("Exam fetch response: ${response.body}");
      
      if (jsonResponse['success'] == true) {
        return GetExam.fromJson(jsonResponse['exam']);
      } else {
        logger.e("Failed to fetch exam: ${jsonResponse['message']}");
        throw Exception(jsonResponse['message'] ?? 'Failed to fetch exam');
      }
    } else {
      logger.e("Failed to fetch exam: ${response.body}");
      throw Exception('Failed to fetch exam');
    }
  }

  // Update exam questions
  Future<void> updateExamQuestions(String examId, List<String> questionIds, String token) async {
    logger.d('Updating exam questions for exam: $examId with questions: $questionIds');
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/exam/$examId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'questions': questionIds,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      logger.d("Update questions response: ${response.body}");
      
      if (jsonResponse['success'] == true) {
        return;
      } else {
        logger.e("Failed to update exam questions: ${jsonResponse['message']}");
        throw Exception(jsonResponse['message'] ?? 'Failed to update exam questions');
      }
    } else {
      logger.e("Failed to update exam questions: ${response.body}");
      throw Exception('Failed to update exam questions');
    }
  }
}