// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AppLanguageProvider extends ChangeNotifier {
  // Supported Languages
  final locales = const <String, Locale>{
    "Arabic": Locale('ar', 'SA'), // Arabic, Saudi Arabia
    "Bengali": Locale('bn', 'BD'), // Bengali, Bangladesh
    "English": Locale('en', 'US'), // English, United States
    "Hindi": Locale('hi', 'IN'), // Hindi, India
    "Indonesian": Locale('id', 'ID'), // Indonesian, Indonesia
    "Korean": Locale('ko', 'KR'), // Korean, South Korea (Republic of Korea)
    "Portuguese": Locale('pt', 'BR'), // Portuguese, Brazil
    "Swahili": Locale('sw', 'KE'), // Swahili, Kenya
    "Thai": Locale('th', 'TH'), // Thai, Thailand
    "Urdu": Locale('ur', 'PK'), // Urdu, Pakistan
  };

  Locale _currentLocale = const Locale("en", "US");
  // Locale _currentLocale = const Locale('ar', 'SA');
  Locale get currentLocale => _currentLocale;
  bool isRTL = false;
  void changeLocale(Locale? value) {
    if (value == null) return;

    _currentLocale = value;
    notifyListeners();
  }
}
