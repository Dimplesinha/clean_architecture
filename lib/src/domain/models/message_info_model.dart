class MessageInfoModel {
  int? statusCode;
  String? message;
  MessageInfoResult? result;
  bool? isSuccess;
  String? utcTimeStamp;

  MessageInfoModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  MessageInfoModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? MessageInfoResult.fromJson(json['result']) : null;
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

class MessageInfoResult {
  int? messageId;
  int? senderId;
  int? receiverId;
  int? groupId;
  String? messageContent;
  int? mediaTypeId;
  String? mediaUrl;
  String? sentAt;
  int? messageStatusId;
  String? deliveredTime;
  String? readTime;

  MessageInfoResult({
    this.messageId,
    this.senderId,
    this.receiverId,
    this.groupId,
    this.messageContent,
    this.mediaTypeId,
    this.mediaUrl,
    this.sentAt,
    this.messageStatusId,
    this.deliveredTime,
    this.readTime,
  });

  MessageInfoResult.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    groupId = json['groupId'];
    messageContent = json['messageContent'];
    mediaTypeId = json['mediaTypeId'];
    mediaUrl = json['mediaUrl'];
    sentAt = json['sentAt'];
    messageStatusId = json['messageStatusId'];
    deliveredTime = json['deliveredTime'];
    readTime = json['readTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageId'] = messageId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['groupId'] = groupId;
    data['messageContent'] = messageContent;
    data['mediaTypeId'] = mediaTypeId;
    data['mediaUrl'] = mediaUrl;
    data['sentAt'] = sentAt;
    data['messageStatusId'] = messageStatusId;
    data['deliveredTime'] = deliveredTime;
    data['readTime'] = readTime;
    return data;
  }
}