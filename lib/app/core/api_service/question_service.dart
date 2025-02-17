// Question Service

import '../api_config/api_config.dart';

import '../../models/exam/question.dart';
import '../../models/exam/get_question.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionService {

  // create question
  Future<void> createQuestion(Question question, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/question/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(question.toJson())
    );
    print('Response: ${response.body}');
    
    if (response.statusCode == 201) {
      print('Question created successfully');
      return;
    }
    throw Exception('Failed to create question');
  }

  // Get all questions
  Future<List<GetQuestion>> getAllQuestions(String token) async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/question/all'), headers: {
      'Authorization': 'Bearer $token'
    });
    
    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> questionsJson = data['questions'];
      return questionsJson.map((json) => GetQuestion.fromJson(json)).toList();
    }
    throw Exception('Failed to load questions');
  }
  
  
}   

