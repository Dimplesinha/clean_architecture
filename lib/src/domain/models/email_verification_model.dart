/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 26-09-2024
/// @Message :

class EmailVerificationResponse {
  int? statusCode;
  String? message;
  EmailVerificationModel? result;
  bool? isSuccess;
  String? utcTimeStamp;

  EmailVerificationResponse(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  EmailVerificationResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? EmailVerificationModel.fromJson(json['result']) : null;
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

class EmailVerificationModel {
  String? token;
  String? uuid;

  EmailVerificationModel({this.token, this.uuid});

  EmailVerificationModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['uuid'] = uuid;
    return data;
  }
}
