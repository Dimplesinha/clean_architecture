import 'package:workapp/src/core/constants/constants.dart';

/// Created by
/// @AUTHOR : Jinal Soni
/// @DATE : 16-10-2023
/// @Message : [ResponseWrapper]
class ResponseWrapper<T> {
  final bool status;
  final String message;
  final T? responseData;

  ResponseWrapper({required this.status, required this.message, this.responseData});

  ResponseWrapper.fromJson(Map<String, dynamic> json):
        status = json[ModelKeys.status],
        message = json[ModelKeys.message],
        responseData = json[ModelKeys.responseData];

  Map<String, dynamic> toJson() => {
    ModelKeys.status: status,
    ModelKeys.message: message,
    ModelKeys.responseData: responseData,
  };
}
