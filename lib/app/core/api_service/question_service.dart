// Question Service

import '../api_config/api_config.dart';

import '../../models/exam/question.dart';
import '../../models/exam/get_question.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionService {

  // create question
  Future<void> createQuestion(Question question, String token) async {
    print('Creating question: ${question.toJson()}');
    // make json body
    Map<String, dynamic> jsonBody = {
      'questionText': question.questionText,
      'questionType': question.questionType,
      'options': question.options,
      'correctOpenEndedAnswer': question.correctOpenEndedAnswer,
      'class': question.classId,
      'subject': question.subjectId,
      'board': question.boardId,
    };
    
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/question/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(jsonBody)
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

  // Get questions by class, subject and board
  Future<List<GetQuestion>> getQuestionsByFilter(String classId, String subjectId, String boardId, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/question/class/$classId/subject/$subjectId/board/$boardId'),
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
    
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> questionsJson = data['questions'];
      return questionsJson.map((json) => GetQuestion.fromJson(json)).toList();
    }
    throw Exception('Failed to load filtered questions');
  }

  // Get question by id
  Future<GetQuestion> getQuestionById(String id, String token) async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/question/$id'), headers: {
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      return GetQuestion.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load question');
  }

  // Update question
  Future<void> updateQuestion(String id, Question question, String token) async {
    final response = await http.put(Uri.parse('${ApiConfig.baseUrl}/question/$id'), headers: {
      'Authorization': 'Bearer $token'
    }, body: jsonEncode(question.toJson()));
    
    if (response.statusCode == 200) {
      return;
    }
    throw Exception('Failed to update question');
  }

  // Delete question
  Future<void> deleteQuestion(String id, String token) async {
    final response = await http.delete(Uri.parse('${ApiConfig.baseUrl}/question/$id'), headers: {
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      return;
    }
    throw Exception('Failed to delete question');
  }
  
}   

