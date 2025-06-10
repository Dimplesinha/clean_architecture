import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/23
/// @Message : [AppTheme]
///
class AppTheme {
  static final AppTheme _singleton = AppTheme._internal();

  AppTheme._internal();

  static AppTheme get instance => _singleton;

  /// Light Theme
  static final lightTheme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionHandleColor: AppColors.primaryColor,
      selectionColor: AppColors.primaryColor,
    ),
    primaryColor: AppColors.primaryColor,
    hintColor: Colors.cyan,
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    cardColor: Colors.white,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontFamilyFallback: const [AppConstants.fontFamilyDMSans],
    typography: Typography(white: TextTheme(displayMedium: FontTypography.defaultTextStyle)),
    listTileTheme: ListTileThemeData(titleTextStyle: FontTypography.defaultTextStyle),
    appBarTheme: AppBarTheme(
        elevation: 3.0,
        scrolledUnderElevation: 5.0,
        color: Colors.white,
        titleTextStyle: TextStyle(
          color: AppColors.jetBlackColor,
        ),
        iconTheme: IconThemeData(color: AppColors.jetBlackColor),
        shadowColor: AppColors.dropShadowColor),
    shadowColor: AppColors.dropShadowColor.withOpacity(0.1),
  );

  /// Dark Theme
  static final darkTheme = ThemeData(
    primaryColor: AppColors.secondaryColor,
    hintColor: Colors.cyanAccent,
    useMaterial3: true,
    cardColor: Colors.black12,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontFamilyFallback: const [AppConstants.fontFamilyDMSans],
    typography: Typography(
      white: TextTheme(
        displayMedium: FontTypography.defaultTextStyle.copyWith(
          color: Colors.blue,
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: FontTypography.defaultTextStyle.copyWith(color: Colors.white),
    ),
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      elevation: 5.0,
      scrolledUnderElevation: 5.0,
      color: Colors.black,
      titleTextStyle: TextStyle(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
