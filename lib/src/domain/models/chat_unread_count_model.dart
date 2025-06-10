class ChatUnreadCountModel {
  int? statusCode;
  String? message;
  ChatUnreadCountResult? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ChatUnreadCountModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  ChatUnreadCountModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? ChatUnreadCountResult.fromJson(json['result']) : null;
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

class ChatUnreadCountResult {
  int? unreadCount;

  ChatUnreadCountResult({this.unreadCount});

  ChatUnreadCountResult.fromJson(Map<String, dynamic> json) {
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['unreadCount'] = unreadCount;
    return data;
  }
}