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
  Future<CreateSubjectResponse> createSubject(
    String subjectName, 
    String subjectDescription, 
    String subjectImage,  // Now expects the image URL
    String token, 
    String classId
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/subject/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': subjectName,
        'description': subjectDescription,
        'class': classId,
        'subjectImage': subjectImage,
      }),
    );
    
    if (response.statusCode == 201) {
      logger.i('Subject created successfully');
      return CreateSubjectResponse(success: true, message: 'Subject created successfully');
    } else {
      logger.e('Failed: ${response.body}');
      return CreateSubjectResponse(success: false, message: jsonDecode(response.body)['message']);
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

  // fetch subject by id
Future<Subject> fetchSubjectById(String subjectId, String token) async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/subject/$subjectId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (jsonResponse['success']) {
      return Subject.fromJson(jsonResponse['subject']);  // Access the 'subject' field
    } else {
      throw Exception('Failed to fetch subject: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Failed to fetch subject');
  }
}

  Future<String> uploadSubjectImage(
    Uint8List imageBytes,
    String imageName,
    String subjectName,
    String prevSubjectImage, {required Null Function(dynamic progress) onProgress}
  ) async {
    // Determine MIME type based on the file extension
    String mimeType;
    if (imageName.endsWith('.jpg') || imageName.endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
    } else if (imageName.endsWith('.png')) {
      mimeType = 'image/png';
    } else if (imageName.endsWith('.webp')) {
      mimeType = 'image/webp';
    } else {
      throw Exception('Unsupported file format. Only JPG, PNG, and WEBP are allowed.');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/subject/uploadimage'),
    );

    // Add the required title field
    request.fields['title'] = subjectName;  // Using subjectName as the title
    request.fields['subjectName'] = subjectName;
    request.fields['prevSubjectImage'] = prevSubjectImage;

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'subjectImage',
      imageBytes,
      filename: imageName,
      contentType: MediaType.parse(mimeType),
    ));

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody.body);
      if (jsonResponse['success']) {
        logger.i('Subject image uploaded successfully');
        return jsonResponse['subjectImage'];
      } else {
        logger.e('Failed to upload subject image');
        throw Exception('Failed to upload subject image');
      }
    } else {
      logger.e('Failed to upload subject image: ${responseBody.body}');
      throw Exception('Failed to upload subject image: ${responseBody.body}');
    }
  }

  Future<bool> updateSubject(
    String subjectId,
    String subjectName,
    String subjectDescription,
    String classId,
    String subjectImage,
    String token,
  ) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/subject/$subjectId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': subjectName,
        'description': subjectDescription,
        'class': classId,
        'subjectImage': subjectImage,
      }),
    );

    if (response.statusCode == 200) {
      logger.i('Subject updated successfully');
      return true;
    } else {
      logger.e('Failed to update subject: ${response.body}');
      throw Exception('Failed to update subject: ${response.body}');
    }
  }
}


