/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message : [SubscriptionHistoryResponse]

class SubscriptionHistoryResponse {
  int? statusCode;
  String? message;
  List<SubscriptionHistoryResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  SubscriptionHistoryResponse({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  SubscriptionHistoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <SubscriptionHistoryResult>[];
      json['result'].forEach((v) {
        result!.add(SubscriptionHistoryResult.fromJson(v));
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

class SubscriptionHistoryResult {
  int? count;
  List<SubscriptionList>? items;

  SubscriptionHistoryResult({this.count, this.items});

  SubscriptionHistoryResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <SubscriptionList>[];
      json['items'].forEach((v) {
        items!.add(SubscriptionList.fromJson(v));
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

class SubscriptionList {
  String? dateCreated;
  String? purchaseToken;
  String? dateModified;
  int? subscriptionId;
  String? transactionId;
  String? title;
  String? subscriptionStatus;
  String? description;
  int? listingLimit;
  int? transferLimit;
  int? boostLimit;
  int? duration;
  dynamic price;
  bool? isTransferable;
  bool? isCanceled;
  String? durationTypeName;
  String? recordStatus;
  int? countryId;
  String? currencySymbol;
  String? currencyCode;
  String? countryName;
  String? planName;
  String? purchaseDate;
  String? startDate;
  String? endDate;
  String? expireDate;
  String? iosSubscriptionPlanId;
  String? androidSubscriptionPlanId;
  List<CountryPrice>? countryPrice;

  SubscriptionList(
      {this.dateCreated,
      this.dateModified,
      this.purchaseToken,
      this.subscriptionId,
      this.transactionId,
      this.subscriptionStatus,
      this.title,
      this.description,
      this.listingLimit,
      this.transferLimit,
      this.boostLimit,
      this.duration,
      this.price,
      this.isTransferable,
      this.isCanceled,
      this.durationTypeName,
      this.recordStatus,
      this.countryId,
      this.currencySymbol,
      this.currencyCode,
      this.countryName,
      this.planName,
      this.purchaseDate,
      this.expireDate,
      this.iosSubscriptionPlanId,
      this.androidSubscriptionPlanId,
      this.startDate,
      this.endDate,
      this.countryPrice});

  SubscriptionList.fromJson(Map<String, dynamic> json) {
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    subscriptionId = json['subscriptionId'];
    transactionId = json['transactionId'];
    subscriptionStatus = json['subscriptionStatus'];
    title = json['title'];
    purchaseToken = json['purchaseToken'];
    description = json['description'];
    listingLimit = json['listingLimit'];
    transferLimit = json['transferLimit'];
    boostLimit = json['boostLimit'];
    duration = json['duration'];
    price = json['price'];
    isTransferable = json['isTransferable'];
    isCanceled = json['isCanceled'];
    durationTypeName = json['durationTypeName'];
    recordStatus = json['recordStatus'];
    countryId = json['countryId'];
    currencySymbol = json['currencySymbol'];
    currencyCode = json['currencyCode'];
    countryName = json['countryName'];
    planName = json['planName'];
    purchaseDate = json['purchaseDate'];
    expireDate = json['expireDate'];
    iosSubscriptionPlanId = json['iosSubscriptionPlanId'];
    androidSubscriptionPlanId = json['androidSubscriptionPlanId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    if (json['countryPrice'] != null) {
      countryPrice = <CountryPrice>[];
      json['countryPrice'].forEach((v) {
        countryPrice!.add(CountryPrice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['subscriptionId'] = subscriptionId;
    data['transactionId'] = transactionId;
    data['subscriptionStatus'] = subscriptionStatus;
    data['title'] = title;
    data['purchaseToken'] = purchaseToken;
    data['description'] = description;
    data['listingLimit'] = listingLimit;
    data['transferLimit'] = transferLimit;
    data['boostLimit'] = boostLimit;
    data['duration'] = duration;
    data['price'] = price;
    data['isTransferable'] = isTransferable;
    data['isCanceled'] = isCanceled;
    data['durationTypeName'] = durationTypeName;
    data['recordStatus'] = recordStatus;
    data['countryId'] = countryId;
    data['currencySymbol'] = currencySymbol;
    data['currencyCode'] = currencyCode;
    data['countryName'] = countryName;
    data['planName'] = planName;
    data['purchaseDate'] = purchaseDate;
    data['expireDate'] = expireDate;
    data['iosSubscriptionPlanId'] = iosSubscriptionPlanId;
    data['androidSubscriptionPlanId'] = androidSubscriptionPlanId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    if (countryPrice != null) {
      data['countryPrice'] = countryPrice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryPrice {
  int? price;
  int? countryId;
  bool? isDeleted;

  CountryPrice({this.price, this.countryId, this.isDeleted});

  CountryPrice.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    countryId = json['countryId'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['countryId'] = countryId;
    data['isDeleted'] = isDeleted;
    return data;
  }
}
