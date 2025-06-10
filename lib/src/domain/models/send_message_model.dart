import 'package:workapp/src/domain/models/chat/chat_result_common_model.dart';

class SendMessageModel {
  int? statusCode;
  String? message;
  ChatResultCommonModel? result;
  bool? isSuccess;
  String? utcTimeStamp;

  SendMessageModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  SendMessageModel.fromJson(Map<String, dynamic> json) {
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

class TypingStatusModel {
  int? senderId;
  int? receiverId;
  int? itemListId;
  bool? isType;

  TypingStatusModel({
    this.senderId,
    this.receiverId,
    this.itemListId,
    this.isType,
  });

  TypingStatusModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    itemListId = json['itemListId'];
    isType = json['isType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['itemListId'] = itemListId;
    data['isType'] = isType;
    return data;
  }
}