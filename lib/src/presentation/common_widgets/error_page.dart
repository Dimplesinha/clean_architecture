import 'package:flutter/material.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 03/11/23
/// @Message :
/// [ErrorPage]
class ErrorPage extends StatelessWidget {
  final String? message;
  final bool isFromWebLogin;
  final bool isNetworkError;

  const ErrorPage({
    Key? key,
    this.message,
    this.isFromWebLogin = false,
    this.isNetworkError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            /// TODO: contents for error page goes here
          ],
        )
    );
  }
}
