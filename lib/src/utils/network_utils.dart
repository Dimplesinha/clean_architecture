import 'dart:io';

import 'package:workapp/src/domain/domain_exports.dart';
///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/23
/// @Message : [NetworkUtils]
///
class NetworkUtils{
  static final NetworkUtils _singleton = NetworkUtils._internal();
  NetworkUtils._internal();
  static NetworkUtils get instance => _singleton;

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (ex) {
      ConsoleLogger.instance.print(ex.message);
      return false;
    }
  }
}