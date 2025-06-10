class ChatDetailModel {
  int? statusCode;
  String? message;
  ChatDetailResult? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ChatDetailModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  ChatDetailModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? ChatDetailResult.fromJson(json['result']) : null;
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

class ChatDetailResult {
  bool? isAddedInContact, isBlockedByMe, isBlockedByUser,isDeleted,isDeletedItemListId;

  ChatDetailResult({this.isAddedInContact, this.isBlockedByMe, this.isBlockedByUser,this.isDeleted,this.isDeletedItemListId});

  ChatDetailResult.fromJson(Map<String, dynamic> json) {
    isAddedInContact = json['isAddedInContact'];
    isBlockedByMe = json['isBlockedByMe'];
    isBlockedByUser = json['isBlockedByUser'];
    isDeleted = json['isDeleted'];
    isDeletedItemListId = json['isDeletedItemListId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isAddedInContact'] = isAddedInContact;
    data['isBlockedByMe'] = isBlockedByMe;
    data['isBlockedByUser'] = isBlockedByUser;
    data['isDeleted'] = isDeleted;
    data['isDeletedItemListId'] = isDeletedItemListId;
    return data;
  }
}