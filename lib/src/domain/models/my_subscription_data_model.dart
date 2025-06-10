class SubscriptionDataModel {
  int? statusCode;
  String? message;
  MySubscriptionData? mySubscriptionData;
  bool? isSuccess;
  String? utcTimeStamp;

  SubscriptionDataModel(
      {this.statusCode,
        this.message,
        this.mySubscriptionData,
        this.isSuccess,
        this.utcTimeStamp});

  SubscriptionDataModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    mySubscriptionData =
    json['result'] != null ? MySubscriptionData.fromJson(json['result']) : null;
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (mySubscriptionData != null) {
      data['result'] = mySubscriptionData!.toJson();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

class MySubscriptionData {
  int? subscriberId;
  int? subscriptionId;
  String? userName;
  String? email;
  int? accountType;
  String? accountTypeValue;
  String? title;
  String? countryName;
  double? price;
  int? listingLimit;
  int? boostLimit;
  int? remainingLimit;
  int? totalListingCount;
  String? recordStatus;
  String? startDate;
  String? endDate;
  int? transferLimit;
  int? totalCount;
  bool? isTransferable;

  MySubscriptionData(
      {this.subscriberId,
        this.subscriptionId,
        this.userName,
        this.email,
        this.accountType,
        this.accountTypeValue,
        this.title,
        this.countryName,
        this.price,
        this.listingLimit,
        this.boostLimit,
        this.remainingLimit,
        this.totalListingCount,
        this.recordStatus,
        this.startDate,
        this.endDate,
        this.transferLimit,
        this.totalCount,
        this.isTransferable});

  MySubscriptionData.fromJson(Map<String, dynamic> json) {
    subscriberId = json['subscriberId'];
    subscriptionId = json['subscriptionId'];
    userName = json['userName'];
    email = json['email'];
    accountType = json['accountType'];
    accountTypeValue = json['accountTypeValue'];
    title = json['title'];
    countryName = json['countryName'];
    price = json['price'];
    listingLimit = json['listingLimit'];
    boostLimit = json['boostLimit'];
    remainingLimit = json['remainingLimit'];
    totalListingCount = json['totalListingCount'];
    recordStatus = json['recordStatus'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    transferLimit = json['transferLimit'];
    totalCount = json['totalCount'];
    isTransferable = json['isTransferable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscriberId'] = subscriberId;
    data['subscriptionId'] = subscriptionId;
    data['userName'] = userName;
    data['email'] = email;
    data['accountType'] = accountType;
    data['accountTypeValue'] = accountTypeValue;
    data['title'] = title;
    data['countryName'] = countryName;
    data['price'] = price;
    data['listingLimit'] = listingLimit;
    data['boostLimit'] = boostLimit;
    data['remainingLimit'] = remainingLimit;
    data['totalListingCount'] = totalListingCount;
    data['recordStatus'] = recordStatus;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['transferLimit'] = transferLimit;
    data['totalCount'] = totalCount;
    data['isTransferable'] = isTransferable;
    return data;
  }
}
