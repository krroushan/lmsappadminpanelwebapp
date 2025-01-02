import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config/api_config.dart'; // Assuming your API config file is here
import '../../models/subject/subject.dart'; // Import the Subject model
import '../../models/subject/subject_create_response.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class SubjectService {
  var logger = Logger();

  Future<List<Subject>> fetchAllSubjects(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/subject/all'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    logger.d('response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        List<Subject> subjects = (jsonResponse['subjects'] as List)
            .map((subjectJson) => Subject.fromJson(subjectJson))
            .toList();
        logger.i('Subjects fetched successfully');
        return subjects;
      } else {
        logger.e('Failed to load subjects: ${jsonResponse['message']}');
        throw Exception('Failed to load subjects: ${jsonResponse['message']}');
      }
    } else {
      logger.e('Failed to load subjects: ${response.statusCode}');
      throw Exception('Failed to load subjects: ${response.statusCode}');
    }
  }

  // Method to create a new class
  Future<CreateSubjectResponse> createSubject(String subjectName, String subjectDescription, Uint8List imageBytes, String imageName, String token, String classId) async {
    // Determine MIME type based on the file extension
    String mimeType;
    if (imageName.endsWith('.jpg') || imageName.endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
    } else if (imageName.endsWith('.png')) {
      mimeType = 'image/png';
    } else if (imageName.endsWith('.webp')) {
      mimeType = 'image/webp';
    } else {
      return CreateSubjectResponse(success: false, message: 'Unsupported file format. Only JPG, PNG, and WEBP are allowed.');
    }
    
    // Implement the API call to upload the subject info and image
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${ApiConfig.baseUrl}/subject/create')
    );
    
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = subjectName;
    request.fields['description'] = subjectDescription;
    request.fields['class'] = classId;

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: imageName,
      contentType: MediaType.parse(mimeType),
    ));

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    
    // Check the response status
    if (response.statusCode == 201) {
      logger.i('Subject created successfully');
      return CreateSubjectResponse(success: true, message: 'Subject created successfully');
    } else {
      logger.e('Failed: ${responseBody.body}');
      return CreateSubjectResponse(success: false, message: jsonDecode(responseBody.body)['message']);
    }
  }

// delete class
Future<void> deleteSubject(String subjectId, String token) async {
    final url = '${ApiConfig.baseUrl}/subject/$subjectId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Replace with your actual token
      },
    );

    if (response.statusCode == 200) {
      logger.i('Class deleted successfully');
      //return jsonDecode(response.body);
    } else {
      logger.e('Failed to delete class');
      throw Exception('Failed to delete class');
    }
  }
}