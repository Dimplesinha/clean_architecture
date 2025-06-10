class BlockUnBlockModel {
  int? statusCode;
  String? message;
  BlockUnBlockResult? result;
  bool? isSuccess;
  String? utcTimeStamp;

  BlockUnBlockModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  BlockUnBlockModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? BlockUnBlockResult.fromJson(json['result']) : null;
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

class BlockUnBlockResult {
  int? userId;
  int? blockedUserId;
  bool? isBlock;

  BlockUnBlockResult(
      {this.userId,
        this.blockedUserId,
        this.isBlock});

  BlockUnBlockResult.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    blockedUserId = json['blockedUserId'];
    isBlock = json['isBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['blockedUserId'] = blockedUserId;
    data['isBlock'] = isBlock;
    return data;
  }
}