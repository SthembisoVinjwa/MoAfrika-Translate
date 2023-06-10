import 'package:flutter/foundation.dart';

class MainProvider with ChangeNotifier {
  bool _darkMode = true;

  bool get isDarkMode => _darkMode;

  void updateMode(bool mode) {
    _darkMode = mode;
    notifyListeners();
  }
}
