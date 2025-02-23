import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config/api_config.dart';
import '../../models/board/board.dart'; 
import '../../models/board/create_board_response.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class BoardService {
  var logger = Logger();

  

  Future<List<Board>> fetchAllBoards(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/board/all'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    print('response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        List<Board> boards = (jsonResponse['boards'] as List)
            .map((boardJson) => Board.fromJson(boardJson))
            .toList();
        logger.i('Boards fetched successfully');
        return boards;
      } else {
        logger.e('Failed to load boards');
        throw Exception('Failed to load boards');
      }
    } else {
      logger.e('Failed to load boards: ${response.statusCode}');
      throw Exception('Failed to load boards: ${response.statusCode}');
    }
  }

  // Method to create a new board
  Future<CreateBoardResponse> createBoard(
    String boardName, 
    String boardDescription, 
    String boardImageUrl,
    String token
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/board/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': boardName,
        'description': boardDescription,
        'boardImage': boardImageUrl,
      }),
    );

    if (response.statusCode == 201) {
      logger.i('Board created successfully');
      return CreateBoardResponse(success: true, message: 'Board created successfully');
    } else {
      logger.e('Failed: ${response.body}');
      return CreateBoardResponse(
        success: false, 
        message: jsonDecode(response.body)['message']
      );
    }
  }

// delete board
Future<void> deleteBoard(String boardId, String token) async {
    final url = '${ApiConfig.baseUrl}/board/$boardId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Replace with your actual token
        'Content-Type': 'application/json',
      },
    );

    print('response: ${response}');

    if (response.statusCode == 204) {
      logger.i('Board deleted successfully');
      return;
    } else {
      logger.e('Failed to delete board');
      throw Exception('Failed to delete board');
    }
  }

  Future<String> uploadBoardImage(
    Uint8List imageBytes, 
    String imageName, 
    String name,
    String prevBoardImage,  
    String token
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
      Uri.parse('${ApiConfig.baseUrl}/board/upload-image')
    );

    request.headers['Authorization'] = 'Bearer $token';
    
    // Add the previous board image name if it exists
    request.fields['name'] = name;
    request.fields['prevBoardImage'] = prevBoardImage;

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'boardImage',
      imageBytes,
      filename: imageName,
      contentType: MediaType.parse(mimeType),
    ));

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody.body);
      if (jsonResponse['success']) {
        logger.i('Board image uploaded successfully');
        return jsonResponse['boardImage'];
      } else {
        logger.e('Failed to upload board image');
        throw Exception('Failed to upload board image');
      }
    } else {
      logger.e('Failed to upload board image: ${responseBody.body}');
      throw Exception('Failed to upload board image: ${jsonDecode(responseBody.body)['message']}');
    }
  }

  // Add method to get board by ID
  Future<Map<String, dynamic>> getBoardById(String boardId, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/board/$boardId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        logger.i('Board fetched successfully');
        return {
          'success': true,
          'data': jsonResponse['boardItem']
        };
      } else {
        logger.e('Failed to fetch board');
        throw Exception(jsonResponse['message'] ?? 'Failed to fetch board');
      }
    } else {
      logger.e('Failed to fetch board: ${response.statusCode}');
      throw Exception('Failed to fetch board: ${response.statusCode}');
    }
  }

  // Add method to update board
  Future<CreateBoardResponse> updateBoard(
    String boardId,
    String boardName,
    String boardDescription,
    String boardImageUrl,
    String token
  ) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/board/$boardId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': boardName,
        'description': boardDescription,
        'boardImage': boardImageUrl,
      }),
    );

    if (response.statusCode == 200) {
      logger.i('Board updated successfully');
      return CreateBoardResponse(success: true, message: 'Board updated successfully');
    } else {
      logger.e('Failed to update board: ${response.body}');
      return CreateBoardResponse(
        success: false,
        message: jsonDecode(response.body)['message'] ?? 'Failed to update board'
      );
    }
  }
}