/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11-09-2024
/// @Message : [EnquiryModel]

class EnquiryModel {
  int? statusCode;
  String? message;
  List<StatisticsEnquiryResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  EnquiryModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  EnquiryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <StatisticsEnquiryResult>[];
      json['result'].forEach((v) {
        result!.add(StatisticsEnquiryResult.fromJson(v));
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

class StatisticsEnquiryResult {
  int? count;
  List<StatisticsEnquiryItem>? items;

  StatisticsEnquiryResult({this.count, this.items});

  StatisticsEnquiryResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <StatisticsEnquiryItem>[];
      json['items'].forEach((v) {
        items!.add(StatisticsEnquiryItem.fromJson(v));
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

class StatisticsEnquiryItem {
  String? uuid;
  int? senderId;
  String? userName;
  String? profilePic;
  String? location;
  String? sendAt;
  int? receiverId;
  int? messageListId;
  int? totalCount;

  StatisticsEnquiryItem({
    this.uuid,
    this.senderId,
    this.userName,
    this.profilePic,
    this.location,
    this.sendAt,
    this.receiverId,
    this.messageListId,
    this.totalCount
  });

  StatisticsEnquiryItem.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    senderId = json['senderId'];
    userName = json['userName'];
    profilePic = json['profilePic'];
    location = json['location'];
    sendAt = json['sendAt'];
    receiverId = json['receiverId'];
    messageListId = json['messageListId'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['uuid'] = uuid;
    data['senderId'] = senderId;
    data['userName'] = userName;
    data['profilePic'] = profilePic;
    data['location'] = location;
    data['sendAt'] = sendAt;
    data['receiverId'] = receiverId;
    data['messageListId'] = messageListId;
    data['totalCount'] = totalCount;
    return data;
  }
}
