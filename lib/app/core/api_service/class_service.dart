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

  Future<ClassInfo> getClassById(String classId, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/class/$classId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        ClassInfo classInfo = ClassInfo.fromJson(jsonResponse['classItem']);
        logger.i('Class fetched successfully');
        return classInfo;
      } else {
        logger.e('Failed to load class');
        throw Exception('Failed to load class');
      }
    } else {
      logger.e('Failed to load class: ${response.statusCode}');
      throw Exception('Failed to load class: ${response.statusCode}');
    }
  }

  Future<CreateClassResponse> updateClass(
    String classId,
    String className,
    String classDescription,
    Uint8List? imageBytes,
    String? imageName,
    String token,
  ) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiConfig.baseUrl}/class/$classId'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = className;
    request.fields['description'] = classDescription;

    // Only add image if provided
    if (imageBytes != null && imageName != null) {
      String mimeType;
      if (imageName.endsWith('.jpg') || imageName.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else if (imageName.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (imageName.endsWith('.webp')) {
        mimeType = 'image/webp';
      } else {
        return CreateClassResponse(
          success: false,
          message: 'Unsupported file format. Only JPG, PNG, and WEBP are allowed.',
        );
      }

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: imageName,
        contentType: MediaType.parse(mimeType),
      ));
    }

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      logger.i('Class updated successfully');
      return CreateClassResponse(success: true, message: 'Class updated successfully');
    } else {
      logger.e('Failed to update class: ${responseBody.body}');
      return CreateClassResponse(
        success: false,
        message: jsonDecode(responseBody.body)['message'],
      );
    }
  }

  Future<String> uploadClassImage(
    Uint8List imageBytes,
    String imageName,
    String title,
    String prevClassImage,
    String token,
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
      Uri.parse('${ApiConfig.baseUrl}/class/uploadimage'),
    );

    request.fields['title'] = title;
    request.fields['prevClassImage'] = prevClassImage;
    request.files.add(http.MultipartFile.fromBytes(
      'classImage',
      imageBytes,
      filename: imageName,
      contentType: MediaType.parse(mimeType),
    ));

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody.body);
      if (jsonResponse['success']) {
        logger.i('Image uploaded successfully');
        return jsonResponse['classImage'];
      } else {
        logger.e('Failed to upload image');
        throw Exception('Failed to upload image');
      }
    } else {
      logger.e('Failed to upload image: ${responseBody.body}');
      throw Exception('Failed to upload image: ${responseBody.body}');
    }
  }
}