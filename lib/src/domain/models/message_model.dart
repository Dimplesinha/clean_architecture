

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [UserConversationModel]

class UserConversationModel {
  int? code;
  String? success;
  String? message;
  List<UserConversationData>? data;

  UserConversationModel({
    this.code,
    this.success,
    this.message,
    this.data,
  });

  UserConversationModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserConversationData>[];
      json['data'].forEach((v) {
        data!.add(UserConversationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserConversationData {
  String? count;
  String? profilePicUrl;
  String? username;
  String? lastMessage;
  String? time;

  UserConversationData({
    this.count,
    this.profilePicUrl,
    this.username,
    this.lastMessage,
    this.time,
  });

  UserConversationData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    profilePicUrl = json['profilePicUrl'];
    username = json['username'];
    lastMessage = json['lastMessage'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['profilePicUrl'] = profilePicUrl;
    data['username'] = username;
    data['lastMessage'] = lastMessage;
    data['time'] = time;
    return data;
  }

  // String getEnquiryLastMessageDateTime() {
  //   DateTime tmp = DateTimeUtils.instance.stringToDateInLocal(string: time ?? '');
  //
  //   return DateTimeUtils.instance.timeStampToDateTimeInChat(tmp);
  // }
}
