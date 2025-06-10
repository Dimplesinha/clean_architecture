import 'package:flutter/material.dart';

import 'package:workapp/src/presentation/style/theme/app_theme.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 07/11/23
/// @Message : [ThemeNotifier]
///
class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = AppTheme.lightTheme;

  ThemeData get currentTheme => _currentTheme;

  /// Switch Theme
  void toggleTheme() {
    _currentTheme = _currentTheme == AppTheme.lightTheme ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners();
  }
}
