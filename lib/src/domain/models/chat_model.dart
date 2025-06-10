import 'package:workapp/src/domain/models/chat/chat_result_common_model.dart';

class ChatModel {
  int? statusCode;
  String? message;
  ChatData? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ChatModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? ChatData.fromJson(json['result']) : null;
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

class ChatData {
  CurrentUser? currentUser;
  Sender? sender;
  List<Messages>? messages;
  int? messageListId;

  ChatData({this.currentUser, this.sender, this.messages});

  ChatData.fromJson(Map<String, dynamic> json) {
    currentUser = json['currentUser'] != null ? CurrentUser.fromJson(json['currentUser']) : null;
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    messageListId = json['messageListId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currentUser != null) {
      data['currentUser'] = currentUser!.toJson();
    }
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }

    data['messageListId'] = messageListId;
    return data;
  }
}

class CurrentUser {
  int? userId;
  String? userName;
  String? profilePic;

  CurrentUser({this.userId, this.userName, this.profilePic});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = userId;
    data['userName'] = userName;
    data['profilePic'] = profilePic;
    return data;
  }
}

class Sender {
  int? userId;
  String? userName;
  String? profilePic;

  Sender({this.userId, this.userName, this.profilePic});

  Sender.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = userId;
    data['userName'] = userName;
    data['profilePic'] = profilePic;
    return data;
  }
}

class Messages {
  int? count;
  List<ChatResultCommonModel>? items;

  Messages({this.count, this.items});

  Messages.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <ChatResultCommonModel>[];
      json['items'].forEach((v) {
        items!.add(ChatResultCommonModel.fromJson(v));
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
