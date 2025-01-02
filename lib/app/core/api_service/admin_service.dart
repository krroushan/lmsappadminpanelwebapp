// 🐦 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// 🌎 Project imports:
import '../api_config/api_config.dart';
import '../../models/admin/admin.dart';
import '../../models/admin/admin_create.dart';

class AdminService {
  var logger = Logger();

  Future<List<Admin>> fetchAllAdmins(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/admin/all'),
      headers: {
        'Authorization': 'Bearer $token', // Include token if required
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        List<Admin> admins = (jsonResponse['admins'] as List)
            .map((adminJson) => Admin.fromJson(adminJson))
            .toList();
        logger.i('Admins fetched successfully');
        return admins;
      } else {
        logger.e('Failed to load admins');
        throw Exception('Failed to load admins');
      }
    } else {
      logger.e('Failed to load admins: ${response.statusCode}');
      throw Exception('Failed to load admins: ${response.statusCode}');
    }
  }

  //delete teacher
  Future<void> deleteAdmin(String adminId, String token) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/admin/$adminId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      logger.i('Admin deleted successfully');
      return;
    } else {
      logger.e('Failed to delete admin');
      throw Exception('Failed to delete admin');
    }
  }

//create teacher
  Future<void> createAdmin(AdminCreate admin, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/admin/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(admin.toJson()),
    );

    logger.i("response: ${response.body}");

    if (response.statusCode == 201) { 
      logger.i('Admin created successfully');
      return;
    } else {
      // Parse and print error messages
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      if (errorResponse['message'] != null || errorResponse['errors'] != null) {
        logger.e(errorResponse['message'] ?? errorResponse['errors']); 
        throw Exception(errorResponse['message'] ?? errorResponse['errors']); 
      } else {
        logger.e('Failed to create admin');
        throw Exception('Failed to create admin'); 
      }
    }
  }
}
