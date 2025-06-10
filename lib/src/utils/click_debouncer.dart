import 'dart:async';

import 'package:flutter/material.dart';
///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 03/11/23
/// @Message : [ClickDebouncer]
/// @Usage =>
/// ```
/// final debouncer = ClickDebouncer(milliseconds: 500);
///   debouncer.run(() {
///     print('Hello World');
///   });
/// ```
///
class ClickDebouncer {
  final int milliseconds;
  Timer? _timer;

  ClickDebouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}