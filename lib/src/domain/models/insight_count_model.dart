class InsightCountModel {
  int? statusCode;
  String? message;
  InsightCountResult? result;
  bool? isSuccess;
  String? utcTimeStamp;

  InsightCountModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  InsightCountModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? InsightCountResult.fromJson(json['result']) : null;
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

class InsightCountResult {
  String? totalListingCalls;
  String? totalListingEmails;
  String? totalListingMessages;
  String? totalListingWebsites;
  String? totalListingViews;

  InsightCountResult(
      {this.totalListingCalls,
        this.totalListingEmails,
        this.totalListingMessages,
        this.totalListingWebsites,
        this.totalListingViews});

  InsightCountResult.fromJson(Map<String, dynamic> json) {
    totalListingCalls = json['totalListingCalls'];
    totalListingEmails = json['totalListingEmails'];
    totalListingMessages = json['totalListingMessages'];
    totalListingWebsites = json['totalListingWebsites'];
    totalListingViews = json['totalListingViews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalListingCalls'] = totalListingCalls;
    data['totalListingEmails'] = totalListingEmails;
    data['totalListingMessages'] = totalListingMessages;
    data['totalListingWebsites'] = totalListingWebsites;
    data['totalListingViews'] = totalListingViews;
    return data;
  }
}