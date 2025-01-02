// lib/app/core/api_service/study_material_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/study-material/study-material.dart';
import '../api_config/api_config.dart';
import '../../models/study-material/study_material_create.dart';
import 'package:logger/logger.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';


class StudyMaterialService {
  final Logger logger = Logger();
  final String baseUrl = ApiConfig.baseUrl; // Base URL for the API

  // Fetch all study materials
  Future<List<StudyMaterial>> fetchAllStudyMaterials(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/study-material/all'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    logger.d(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // Extract the study materials from the response
      final List<StudyMaterial> studyMaterials = (jsonResponse['studyMaterials'] as List)
          .map((json) => StudyMaterial.fromJson(json))
          .toList();
      return studyMaterials;
    } else {
      throw Exception('Failed to load study materials: ${response.statusCode}');
    }
  }

  // Create a new study material
  Future<void> createStudyMaterial(
    StudyMaterialCreate studyMaterialCreate,
    String token
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/study-material/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(studyMaterialCreate.toJson()),
    );

    if (response.statusCode == 201) {
      logger.d(response.body);
      return;
    } else {
      throw Exception('Failed to create study material: ${response.body}');
    }
  }

  // Update an existing study material
  Future<StudyMaterial> updateStudyMaterial(String id, StudyMaterial studyMaterial, String token) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/study-material/update/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(studyMaterial.toJson()),
    );

    if (response.statusCode == 200) {
      return StudyMaterial.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update study material: ${response.statusCode}');
    }
  }

  // Delete a study material
  Future<void> deleteStudyMaterial(String id, String token) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/study-material/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete study material: ${response.statusCode}');
    }
  }

    // Method to create a new class
  Future<void> createStudyMaterial2(String title, String description, String type, Uint8List fileBytes, String fileName, String classId, String subjectId, String teacherId, String token) async {
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
      Uri.parse('${ApiConfig.baseUrl}/study-material/create')
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
    request.fields['description'] = description;
    request.fields['type'] = type;
    request.fields['class'] = classId;
    request.fields['subject'] = subjectId;
    request.fields['teacher'] = teacherId;


    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    
    // Check the response status
    if (response.statusCode == 201) {
      logger.i('Study Material created successfully');
      return;
    } else {
      logger.e('Failed: ${responseBody.body}');
      throw Exception('Failed: ${responseBody.body}');
    }
  }
}