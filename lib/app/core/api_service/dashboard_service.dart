import '../api_config/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/student/student_all_response.dart';

class DashboardService {
  // Get all students with pagination
  Future<List<StudentAllResponse>> fetchStudents(int page, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/student/page/$page'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("response: ${response.body}");

    if (response.statusCode == 200) {
      List<StudentAllResponse> studentAllResponse = [];
      studentAllResponse.add(StudentAllResponse.fromJson(jsonDecode(response.body)));
      print("studentAllResponse: ${studentAllResponse[0].students[0].classInfo.name}");
      return studentAllResponse;
    } else {
      throw Exception('Failed to load students');
    }
  }
}


