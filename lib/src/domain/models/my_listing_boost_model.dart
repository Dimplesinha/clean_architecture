class MyListingBoostResponse {
  int? statusCode;
  String? message;
  MyListingBoostResult? result;
  bool? isSuccess;
  String? utcTimeStamp;

  MyListingBoostResponse(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  MyListingBoostResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? MyListingBoostResult.fromJson(json['result']) : null;
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

class MyListingBoostResult {
  String? dateModified;

  MyListingBoostResult({this.dateModified});

  MyListingBoostResult.fromJson(Map<String, dynamic> json) {
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateModified'] = dateModified;
    return data;
  }
}