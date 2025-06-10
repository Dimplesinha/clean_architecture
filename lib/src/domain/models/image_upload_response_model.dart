import 'dart:convert';

class ImageUploadResponse {
  int? statusCode;
  String? message;
  Result? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ImageUploadResponse(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['isSuccess'] = this.isSuccess;
    data['utcTimeStamp'] = this.utcTimeStamp;
    return data;
  }
}

class Result {
  String? fileName;

  Result({this.fileName});

  Result.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    return data;
  }
}