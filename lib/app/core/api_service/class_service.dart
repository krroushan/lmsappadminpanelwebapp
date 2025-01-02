import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config/api_config.dart'; // Assuming your API config file is here
import '../../models/classes/class_info.dart'; // Import the ClassInfo model
import '../../models/classes/create_class_response.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class ClassService {
  var logger = Logger();

  Future<List<ClassInfo>> fetchAllClasses(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/class/all'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        List<ClassInfo> classes = (jsonResponse['classes'] as List)
            .map((classJson) => ClassInfo.fromJson(classJson))
            .toList();
        logger.i('Classes fetched successfully');
        return classes;
      } else {
        logger.e('Failed to load classes');
        throw Exception('Failed to load classes');
      }
    } else {
      logger.e('Failed to load classes: ${response.statusCode}');
      throw Exception('Failed to load classes: ${response.statusCode}');
    }
  }

  // Method to create a new class
  Future<CreateClassResponse> createClass(String className, String classDescription, Uint8List imageBytes, String imageName, String token) async {
    // Determine MIME type based on the file extension
    String mimeType;
    if (imageName.endsWith('.jpg') || imageName.endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
    } else if (imageName.endsWith('.png')) {
      mimeType = 'image/png';
    } else if (imageName.endsWith('.webp')) {
      mimeType = 'image/webp';
    } else {
      return CreateClassResponse(success: false, message: 'Unsupported file format. Only JPG, PNG, and WEBP are allowed.');
    }
    
    // Implement the API call to upload the class info and image
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${ApiConfig.baseUrl}/class/create')
    );
    
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = className;
    request.fields['description'] = classDescription;

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
      logger.i('Class created successfully');
      return CreateClassResponse(success: true, message: 'Class created successfully');
    } else {
      logger.e('Failed: ${responseBody.body}');
      return CreateClassResponse(success: false, message: jsonDecode(responseBody.body)['message']);
    }
  }

// delete class
Future<void> deleteClass(String classId, String token) async {
    final url = '${ApiConfig.baseUrl}/class/$classId';
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