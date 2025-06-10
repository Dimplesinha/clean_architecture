class MyListingStatusResponseModel {
  int? statusCode;
  String? message;
  MyListingStatusResponse? result;
  bool? isSuccess;
  String? utcTimeStamp;

  MyListingStatusResponseModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  MyListingStatusResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? MyListingStatusResponse.fromJson(json['result']) : null;
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

class MyListingStatusResponse {
  bool? isRequiredFieldFilled;
  bool? status;

  MyListingStatusResponse({this.isRequiredFieldFilled, this.status});

  MyListingStatusResponse.fromJson(Map<String, dynamic> json) {
    isRequiredFieldFilled = json['isRequiredFieldFilled'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRequiredFieldFilled'] = isRequiredFieldFilled;
    data['status'] = status;
    return data;
  }
}
