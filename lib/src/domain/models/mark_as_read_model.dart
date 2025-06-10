import 'package:workapp/src/domain/models/chat/chat_result_common_model.dart';

class MarkAsReadModel {
  int? statusCode;
  String? message;
  ChatResultCommonModel? result;
  bool? isSuccess;
  String? utcTimeStamp;

  MarkAsReadModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  MarkAsReadModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? ChatResultCommonModel.fromJson(json['result']) : null;
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['result'] = result;
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}