   import 'package:flutter/material.dart';
   import 'package:shared_preferences/shared_preferences.dart';
   import 'package:go_router/go_router.dart';

   class AuthProvider with ChangeNotifier {
     bool _isAuthenticated = false;
     String _name = '';
     String _role = '';
     String _userId = '';
     String _token = '';

     bool get isAuthenticated => _isAuthenticated;
     String get getName => _name;
     String get getRole => _role;
     String get getUserId => _userId;
     String get getToken => _token;

     Future<void> login(String token, String name, String role, String userId) async {
       final prefs = await SharedPreferences.getInstance();
       await prefs.setString('token', token);
       await prefs.setString('name', name);
       await prefs.setString('role', role);
       await prefs.setString('userId', userId);
       _isAuthenticated = true;
       _name = name;
       _role = role;
       _userId = userId;
       _token = token;
       notifyListeners(); // Notify listeners about the change
     }

     Future<void> logout(BuildContext context) async {
       final prefs = await SharedPreferences.getInstance();
       await prefs.remove('token');
       await prefs.remove('name');
       await prefs.remove('role');
       await prefs.remove('userId');
       _isAuthenticated = false;
       _name = '';
       _role = '';
       _userId = '';
       _token = '';
       GoRouter.of(context).go('/');
       notifyListeners(); // Notify listeners about the change
     }

     Future<void> checkAuthentication() async {
       final prefs = await SharedPreferences.getInstance();
       final token = prefs.getString('token');
       final name = prefs.getString('name');
       final role = prefs.getString('role');
       final userId = prefs.getString('userId');

       _isAuthenticated = token != null;
       _token = token ?? '';
       _name = name ?? '';
       _role = role ?? '';
       _userId = userId ?? '';
       
       notifyListeners(); // Notify listeners about the change
     }
   }