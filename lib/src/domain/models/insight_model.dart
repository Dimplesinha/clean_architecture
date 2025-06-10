class InsightResponseModel {
  int? statusCode;
  String? message;
  List<InsightResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  InsightResponseModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  InsightResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <InsightResult>[];
      json['result'].forEach((v) {
        result!.add(InsightResult.fromJson(v));
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

class InsightResult {
  int? count;
  List<InsightItems>? items;

  InsightResult({this.count, this.items});

  InsightResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <InsightItems>[];
      json['items'].forEach((v) {
        items!.add(InsightItems.fromJson(v));
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

class InsightItems {
  int? listingId;
  String? listingName;
  String? status;
  int? categoryId;
  String? callsCount;
  String? emailsCount;
  String? messagesCount;
  String? websitesCount;
  String? viewsCount;
  int? totalCount;

  InsightItems(
      {this.listingId,
        this.listingName,
        this.status,
        this.categoryId,
        this.callsCount,
        this.emailsCount,
        this.messagesCount,
        this.websitesCount,
        this.viewsCount,
        this.totalCount});

  InsightItems.fromJson(Map<String, dynamic> json) {
    listingId = json['listingId'];
    listingName = json['listingName'];
    status = json['status'];
    categoryId = json['categoryId'];
    callsCount = json['callsCount'];
    emailsCount = json['emailsCount'];
    messagesCount = json['messagesCount'];
    websitesCount = json['websitesCount'];
    viewsCount = json['viewsCount'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listingId'] = listingId;
    data['listingName'] = listingName;
    data['status'] = status;
    data['categoryId'] = categoryId;
    data['callsCount'] = callsCount;
    data['emailsCount'] = emailsCount;
    data['messagesCount'] = messagesCount;
    data['websitesCount'] = websitesCount;
    data['viewsCount'] = viewsCount;
    data['totalCount'] = totalCount;
    return data;
  }
}