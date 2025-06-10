import 'package:workapp/src/domain/models/chat/chat_result_common_model.dart';

class ChatListModel {
  int? statusCode;
  String? message;
  List<ChatResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ChatListModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  ChatListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <ChatResult>[];
      json['result'].forEach((v) {
        result!.add(ChatResult.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

class ChatResult {
  int? count;
  List<ChatListResult>? items;

  ChatResult({this.count, this.items});

  ChatResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <ChatListResult>[];
      json['items'].forEach((v) {
        items!.add(ChatListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatListResult {
  int? userId;
  String? userName;
  ChatResultCommonModel? latestMessage;
  int? unreadCount;
  String? profilePic;
  int? messageListId;
  int? itemListId;

  ChatListResult({
    this.userId,
    this.userName,
    this.latestMessage,
    this.unreadCount,
    this.profilePic,
    this.messageListId,
    this.itemListId,
  });

  ChatListResult.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    latestMessage = json['latestMessage'] != null ? ChatResultCommonModel.fromJson(json['latestMessage']) : null;
    unreadCount = json['unreadCount'];
    profilePic = json['profilePic'];
    messageListId = json['messageListId'];
    itemListId = json['itemListId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['latestMessage'] = latestMessage;
    data['unreadCount'] = unreadCount;
    data['profilePic'] = profilePic;
    data['messageListId'] = messageListId;
    data['itemListId'] = itemListId;
    return data;
  }
}
