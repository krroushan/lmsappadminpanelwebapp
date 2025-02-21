// 🐦 Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// 📦 Package imports:
import 'package:acnoo_flutter_admin_panel/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

// 🌎 Project imports:
import '../api_config/api_config.dart';
import '../../models/lecture/lecture.dart';
import '../../models/create_response.dart';

class LectureService {
  var logger = Logger();

  Future<List<Lecture>> fetchAllLectures(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/lecture/all'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      logger.i('jsonResponse: ${jsonResponse}');
      if (jsonResponse['success']) {
        List<Lecture> lectures = (jsonResponse['lectures'] as List)
            .map((lectureJson) => Lecture.fromJson(lectureJson))
            .toList();
        logger.i('Lectures fetched successfully');
        return lectures;
      } else {
        logger.e('Failed to load lectures');
        throw Exception('Failed to load lectures');
      }
    } else {
      logger.e('Failed to load lectures: ${response.statusCode}');
      throw Exception('Failed to load lectures: ${response.statusCode}');
    }
  }

  //delete Lecture
  Future<void> deleteLecture(String lectureId, String token) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/lecture/$lectureId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      logger.i('Lecture deleted successfully');
      return;
    } else {
      logger.e('Failed to delete lecture');
      throw Exception('Failed to delete lecture');
    }
  }

//create Lecture
  Future<CreateResponse> createLectureRecorded(
    String title, 
    String description, 
    Uint8List imageBytes, 
    String imageName,
    String lectureType, 
    Uint8List? videoBytes, 
    String? videoName,
    String boardId,
    String classId, 
    String subjectId, 
    String teacherId, 
    String startDate, 
    String startTime, 
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
      return CreateResponse(success: false, message: 'Unsupported file format. Only JPG, PNG, and WEBP are allowed.', error: 'Unsupported file format. Only JPG, PNG, and WEBP are allowed.');
    }

    // Implement the API call to upload the lecture info and image
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${ApiConfig.baseUrl}/lecture/create')
    );
    
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['lectureType'] = lectureType;
    request.fields['board'] = boardId;
    request.fields['class'] = classId;
    request.fields['subject'] = subjectId;
    request.fields['teacher'] = teacherId;
    request.fields['startDate'] = startDate;
    request.fields['startTime'] = startTime;

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'thumbnail',
      imageBytes,
      filename: imageName,
      contentType: MediaType.parse(mimeType),
    ));

    if (lectureType == 'recorded') {
    // Add the video file to the request
      request.files.add(http.MultipartFile.fromBytes(
        'recordingUrl',
        videoBytes!,
        filename: videoName,
          contentType: MediaType.parse('video/mp4'),
        ));
    } else {
      request.fields['recordingUrl'] = '';
    }

    logger.d('request: $request');

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    
    // Check the response status
    if (response.statusCode == 201) {
      logger.i('Lecture created successfully');
      return CreateResponse(success: true, message: 'Lecture created successfully', error: '');
    } else {
      logger.e('Failed: ${responseBody.body}');
      return CreateResponse(success: false, message: jsonDecode(responseBody.body)['message'], error: jsonDecode(responseBody.body)['error']);
    }

  }

  Future<CreateResponse> createLectureLive(
    String title, 
    String description, 
    Uint8List imageBytes, 
    String imageName,
    String lectureType,
    String boardId,
    String classId, 
    String subjectId, 
    String teacherId, 
    String startDate, 
    String startTime, 
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
      return CreateResponse(success: false, message: 'Unsupported file format. Only JPG, PNG, and WEBP are allowed.', error: 'Unsupported file format. Only JPG, PNG, and WEBP are allowed.');
    }

    // Implement the API call to upload the lecture info and image
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${ApiConfig.baseUrl}/lecture/create')
    );
    
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['lectureType'] = lectureType;
    request.fields['board'] = boardId;
    request.fields['class'] = classId;
    request.fields['subject'] = subjectId;
    request.fields['teacher'] = teacherId;
    request.fields['startDate'] = startDate;
    request.fields['startTime'] = startTime;
    request.fields['recordingUrl'] = '';

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'thumbnail',
      imageBytes,
      filename: imageName,
      contentType: MediaType.parse(mimeType),
    ));

    logger.d('request: $request');

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    
    // Check the response status
    if (response.statusCode == 201) {
      logger.i('Lecture created successfully');
      return CreateResponse(success: true, message: 'Lecture created successfully', error: '');
    } else {
      logger.e('Failed: ${responseBody.body}');
      return CreateResponse(success: false, message: jsonDecode(responseBody.body)['message'], error: jsonDecode(responseBody.body)['error']);
    }

  }

  Future<Lecture> getLectureById(String lectureId, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/lecture/$lectureId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return Lecture.fromJson(jsonResponse['lecture']);
    } else {
      throw Exception('Failed to fetch lecture');
    }
  }

  Future<void> updateLecture(String lectureId, Map<String, dynamic> updateData, String token) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/lecture/$lectureId'),
      headers: {

        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        logger.i('Lecture updated successfully');
        return; //Lecture.fromJson(jsonResponse['lecture']);
      } else {
        logger.e('Failed to update lecture');
        throw Exception('Failed to update lecture');
      }
    } else {
      logger.e('Failed to update lecture: ${response.statusCode}');
      throw Exception('Failed to update lecture: ${response.statusCode}');
    }
  }

  Future<String> uploadLectureThumbnail(
    Uint8List imageBytes,
    String imageName,
    String title,
    String prevThumbnail,
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
      Uri.parse('${ApiConfig.baseUrl}/lecture/uploadthumbnail'),
    );

    //request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['prevThumbnail'] = prevThumbnail;
    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'thumbnail',
      imageBytes,
      filename: imageName,
      contentType: MediaType.parse(mimeType),
    ));

    

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody.body);
      if (jsonResponse['success']) {
        logger.i('Thumbnail uploaded successfully');
        return jsonResponse['thumbnailImage'];
      } else {
        logger.e('Failed to upload thumbnail');
        throw Exception('Failed to upload thumbnail');
      }
    } else {
      logger.e('Failed to upload thumbnail: ${responseBody}');
      throw Exception('Failed to upload thumbnail: ${responseBody}');
    }
  }

  Future<String> uploadLectureVideo(
    Uint8List videoBytes,
    String videoName,
    String title,
    String prevVideo,
    String token,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/lecture/uploadlecture'),
    );

    request.fields['title'] = title;
    request.fields['prevVideoFile'] = prevVideo;
    
    // Add the video file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'recordingUrl',
      videoBytes,
      filename: videoName,
      contentType: MediaType.parse('video/mp4'),
    ));

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody.body);
      if (jsonResponse['success']) {
        logger.i('Video uploaded successfully');
        return jsonResponse['recordingUrl'];
      } else {
        logger.e('Failed to upload video');
        throw Exception('Failed to upload video');
      }
    } else {
      logger.e('Failed to upload video: ${responseBody}');
      throw Exception('Failed to upload video: ${responseBody}');
    }
  }

}
