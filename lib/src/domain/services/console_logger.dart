import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/constants.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 03/11/23
/// @Message : [ConsoleLogger]
///
ValueNotifier<bool> isConsoleLoggerEnabled = ValueNotifier(false);

/// [Logger]
abstract class Logger{
  const Logger();

  void print(String message);
}

/// [ConsoleLogger]
class ConsoleLogger extends Logger{
  static final ConsoleLogger _singleton = ConsoleLogger._internal();
  ConsoleLogger._internal();
  static ConsoleLogger get instance => _singleton;

  @override
  void print(String message) {
    if(isConsoleLoggerEnabled.value == true){
      /// Print in Debug Mode
      debugPrint('${DateTime.now()} [${AppConstants.appTitleStr}] : $message');
    }
  }

  /// Enable Console Logger
  void enableConsoleLogger(){
    isConsoleLoggerEnabled.value = true;
  }

  /// Disable Console Logger
  void disableConsoleLogger(){
    isConsoleLoggerEnabled.value = false;
  }
}