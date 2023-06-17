import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  bool _darkMode = true;
  List<DropdownMenuItem<String>> languages = [];

  bool get isDarkMode => _darkMode;
  List<DropdownMenuItem<String>> get languagesPreference => languages;

  void updateMode(bool mode) {
    _darkMode = mode;
    notifyListeners();
  }

  void updateLanguages(List<DropdownMenuItem<String>> newLanguages) {
    languages = newLanguages;
    notifyListeners();
  }
}
