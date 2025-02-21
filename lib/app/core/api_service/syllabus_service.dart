// lib/app/core/api_service/study_material_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/syllabus/syllabus.dart';
import '../api_config/api_config.dart';
import '../../models/syllabus/syllabus_create.dart';
import '../../models/syllabus/syllabus_update.dart';
import 'package:logger/logger.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';


class SyllabusService {
  final Logger logger = Logger();
  final String baseUrl = ApiConfig.baseUrl; // Base URL for the API

  // Fetch all study materials
  Future<List<Syllabus>> fetchAllSyllabuses(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/syllabus/all'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    logger.d(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // Extract the study materials from the response
      final List<Syllabus> syllabuses = (jsonResponse['syllabuses'] as List)
          .map((json) => Syllabus.fromJson(json))
          .toList();
      return syllabuses;
    } else {
      throw Exception('Failed to load study materials: ${response.statusCode}');
    }
  }

  // Create a new study material
  Future<void> createSyllabus(
    SyllabusCreate syllabusCreate,
    String token
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/syllabus/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(syllabusCreate.toJson()),
    );

    if (response.statusCode == 201) {
      logger.d(response.body);
      return;
    } else {
      throw Exception('Failed to create study material: ${response.body}');
    }
  }

  // Update an existing study material
  Future<void> updateSyllabus(String id, SyllabusUpdate syllabus, String token) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/syllabus/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(syllabus.toJson()),
    );

    logger.d(response.body);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update study material: ${response.statusCode}');
    }
  }

  // Delete a study material
  Future<void> deleteSyllabus(String id, String token) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/syllabus/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete study material: ${response.statusCode}');
    }

  }

  // Fetch a study material by ID
  Future<Syllabus> fetchSyllabusById(String id, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/syllabus/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    logger.d(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return Syllabus.fromJson(jsonResponse['syllabus']);
    } else {
      throw Exception('Failed to load study material: ${response.statusCode}');
    }
  }

    // Method to create a new class
  Future<void> createSyllabus2(
    String title, 
    Uint8List fileBytes, 
    String fileName, String classId, 
    String subjectId, String teacherId, String boardId, String token) async {
    // Determine MIME type based on the file extension
    String mimeType;
    if (fileName.endsWith('.pdf')) {
      mimeType = 'application/pdf';
    } else {
      throw Exception('Unsupported file format. Only PDF are allowed.');
    }
    
    // Implement the API call to upload the class info and image
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${ApiConfig.baseUrl}/syllabus/create')
    );
    
    request.headers['Authorization'] = 'Bearer $token';

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'fileUrl',
      fileBytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    ));

    request.fields['title'] = title;
    request.fields['class'] = classId;
    request.fields['subject'] = subjectId;
    request.fields['teacher'] = teacherId;
    request.fields['board'] = boardId;

    logger.d('syllabus request: $request');


    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    
    // Check the response status
    if (response.statusCode == 201) {
      logger.i('Syllabus created successfully');
      return;
    } else {
      logger.e('Failed: ${responseBody.body}');
      throw Exception('Failed: ${responseBody.body}');
    }
  }

  // upload pdf

    Future<String> uploadSyllabusPdf(
      String title, 
      Uint8List fileBytes, 
      String fileName, 
      String prevPdfUrl,
      String token
      ) async {
    // Determine MIME type based on the file extension
    String mimeType;
    if (fileName.endsWith('.pdf')) {
      mimeType = 'application/pdf';
    } else {
      throw Exception('Unsupported file format. Only PDF are allowed.');
    }
    
    // Implement the API call to upload the class info and image
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${ApiConfig.baseUrl}/syllabus/uploadpdf')
    );
    
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['prevPdfFile'] = prevPdfUrl;

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'fileUrl',
      fileBytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    ));

    logger.d('syllabus request: $request');


    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    
    if (response.statusCode == 200) {
      logger.i('Syllabus PDF uploaded successfully');
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody.body);
      return jsonResponse['fileUrl'];
    } else {
      logger.e('Failed: ${responseBody.body}');
      throw Exception('Failed: ${responseBody.body}');
    }
  }



  

}