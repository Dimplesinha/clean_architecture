class PromoCodeList {
  int? statusCode;
  String? message;
  List<PromoCodeData>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  PromoCodeList(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  PromoCodeList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <PromoCodeData>[];
      json['result'].forEach((v) {
        result!.add(PromoCodeData.fromJson(v));
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

class PromoCodeData {
  int? count;
  List<PromoCodeItems>? items;

  PromoCodeData({this.count, this.items});

  PromoCodeData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <PromoCodeItems>[];
      json['items'].forEach((v) {
        items!.add(PromoCodeItems.fromJson(v));
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

class PromoCodeItems {
  int? id;
  int? userId;
  String? userName;
  String? email;
  String? description;
  int? typeOfCodeId;
  String? typeOfCode;
  String? promoCode;
  int? statusId;
  String? status;
  String? startDate;
  String? expireDate;
  String? redeemDate;
  int? discountPercentage;
  double? discountAmount;
  int? subscriptionId;
  String? title;
  int? targetAudienceId;
  String? targetAudience;
  int? mailSentTypeId;
  String? mailSentType;
  int? countryId;
  String? country;
  int? recordStatusID;
  String? recordStatus;
  String? dateCreated;
  String? dateModified;

  PromoCodeItems(
      {this.id,
        this.userId,
        this.userName,
        this.email,
        this.description,
        this.typeOfCodeId,
        this.typeOfCode,
        this.promoCode,
        this.statusId,
        this.status,
        this.startDate,
        this.expireDate,
        this.redeemDate,
        this.discountPercentage,
        this.discountAmount,
        this.subscriptionId,
        this.title,
        this.targetAudienceId,
        this.targetAudience,
        this.mailSentTypeId,
        this.mailSentType,
        this.countryId,
        this.country,
        this.recordStatusID,
        this.recordStatus,
        this.dateCreated,
        this.dateModified});

  PromoCodeItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    email = json['email'];
    description = json['description'];
    typeOfCodeId = json['typeOfCodeId'];
    typeOfCode = json['typeOfCode'];
    promoCode = json['promoCode'];
    statusId = json['statusId'];
    status = json['status'];
    startDate = json['startDate'];
    expireDate = json['expireDate'];
    redeemDate = json['redeemDate'];
    discountPercentage = json['discountPercentage'];
    discountAmount = json['discountAmount'];
    subscriptionId = json['subscriptionId'];
    title = json['title'];
    targetAudienceId = json['targetAudienceId'];
    targetAudience = json['targetAudience'];
    mailSentTypeId = json['mailSentTypeId'];
    mailSentType = json['mailSentType'];
    countryId = json['countryId'];
    country = json['country'];
    recordStatusID = json['recordStatusID'];
    recordStatus = json['recordStatus'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['email'] = email;
    data['description'] = description;
    data['typeOfCodeId'] = typeOfCodeId;
    data['typeOfCode'] = typeOfCode;
    data['promoCode'] = promoCode;
    data['statusId'] = statusId;
    data['status'] = status;
    data['startDate'] = startDate;
    data['expireDate'] = expireDate;
    data['redeemDate'] = redeemDate;
    data['discountPercentage'] = discountPercentage;
    data['discountAmount'] = discountAmount;
    data['subscriptionId'] = subscriptionId;
    data['title'] = title;
    data['targetAudienceId'] = targetAudienceId;
    data['targetAudience'] = targetAudience;
    data['mailSentTypeId'] = mailSentTypeId;
    data['mailSentType'] = mailSentType;
    data['countryId'] = countryId;
    data['country'] = country;
    data['recordStatusID'] = recordStatusID;
    data['recordStatus'] = recordStatus;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    return data;
  }
}
