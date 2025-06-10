class ActiveListingModel {
  int? statusCode;
  String? message;
  ListingCount? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ActiveListingModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  ActiveListingModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? ListingCount.fromJson(json['result']) : null;
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

class ListingCount {
  int? businessDeleteCount;
  int? activeListingCount;

  ListingCount({this.businessDeleteCount,this.activeListingCount});

  ListingCount.fromJson(Map<String, dynamic> json) {
    businessDeleteCount = json['businessDeleteCount'];
    activeListingCount = json['activeListingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['businessDeleteCount'] = businessDeleteCount;
    data['activeListingCount'] = activeListingCount;
    return data;
  }
}
