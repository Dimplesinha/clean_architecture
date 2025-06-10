import 'package:flutter/material.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 03/11/23
/// @Message :
/// [HexColor]
///
class HexColor extends Color{
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}