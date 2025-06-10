class PromoCodeAppliedDetails {
  int? statusCode;
  String? message;
  PromoDetails? result;
  bool? isSuccess;
  String? utcTimeStamp;

  PromoCodeAppliedDetails(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  PromoCodeAppliedDetails.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? PromoDetails.fromJson(json['result']) : null;
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

class PromoDetails {
  String?
  promoCode;
  double? discountAmount;
  double? price;
  double? finalAmount;
  String? subscriptionName;
  String? currencyCode;
  int? duration;
  int? countryId;

  int? subscriptionId;
  int? listingLimit;
  String? description;
  String? currencySymbol;
  int? transferLimit;
  int? boostLimit;
  int? durationType;
  bool? isTransferable;
  String? startDate;
  String? endDate;
  int? recordStatusID;
  String? recordStatus;
  String? durationTypeName;
  String? iosSubscriptionPlanId;
  String? androidSubscriptionPlanId;

  PromoDetails(
      {this.promoCode,
        this.subscriptionId,
        this.countryId,
        this.currencyCode,
        this.currencySymbol,
        this.discountAmount,
        this.price,
        this.finalAmount,
        this.subscriptionName,
        this.duration,
        this.listingLimit,
        this.description,
        this.transferLimit,
        this.boostLimit,
        this.durationType,
        this.isTransferable,
        this.startDate,
        this.endDate,
        this.recordStatusID,
        this.recordStatus,
        this.durationTypeName,
        this.iosSubscriptionPlanId,
        this.androidSubscriptionPlanId});

  PromoDetails.fromJson(Map<String, dynamic> json) {
    promoCode = json['promoCode'];
    subscriptionId = json['subscriptionId'];
    countryId = json['countryId'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    discountAmount = json['discountAmount'];
    price = json['price'];
    finalAmount = json['finalAmount'];
    subscriptionName = json['subscriptionName'];
    duration = json['duration'];
    listingLimit = json['listingLimit'];
    description = json['description'];
    transferLimit = json['transferLimit'];
    boostLimit = json['boostLimit'];
    durationType = json['durationType'];
    isTransferable = json['isTransferable'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    recordStatusID = json['recordStatusID'];
    recordStatus = json['recordStatus'];
    durationTypeName = json['durationTypeName'];
    iosSubscriptionPlanId = json['iosSubscriptionPlanId'];
    androidSubscriptionPlanId = json['androidSubscriptionPlanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promoCode'] = promoCode;
    data['subscriptionId'] = subscriptionId;
    data['countryId'] = countryId;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    data['discountAmount'] = discountAmount;
    data['price'] = price;
    data['finalAmount'] = finalAmount;
    data['subscriptionName'] = subscriptionName;
    data['duration'] = duration;
    data['listingLimit'] = listingLimit;
    data['description'] = description;
    data['transferLimit'] = transferLimit;
    data['boostLimit'] = boostLimit;
    data['durationType'] = durationType;
    data['isTransferable'] = isTransferable;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['recordStatusID'] = recordStatusID;
    data['recordStatus'] = recordStatus;
    data['durationTypeName'] = durationTypeName;
    data['iosSubscriptionPlanId'] = iosSubscriptionPlanId;
    data['androidSubscriptionPlanId'] = androidSubscriptionPlanId;
    return data;
  }
}
