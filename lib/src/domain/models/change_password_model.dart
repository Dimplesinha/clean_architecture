class ChangePasswordResponse {
  int? statusCode;
  String? message;
  bool? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ChangePasswordResponse(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'];
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