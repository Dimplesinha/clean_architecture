class PromoCodeValidate {
  int? statusCode;
  String? message;
  ValidatedData? result;
  bool? isSuccess;
  String? utcTimeStamp;

  PromoCodeValidate(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  PromoCodeValidate.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? ValidatedData.fromJson(json['result']) : null;
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

class ValidatedData {
  int? userId;
  String? userName;
  int? typeOfCodeId;
  String? typeOfCode;
  String? startDate;
  String? expireDate;
  int? promoStatusId;
  String? promoStatus;
  int? discountPercentage;

  ValidatedData(
      {this.userId,
        this.userName,
        this.typeOfCodeId,
        this.typeOfCode,
        this.startDate,
        this.expireDate,
        this.promoStatusId,
        this.promoStatus,
        this.discountPercentage});

  ValidatedData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    typeOfCodeId = json['typeOfCodeId'];
    typeOfCode = json['typeOfCode'];
    startDate = json['startDate'];
    expireDate = json['expireDate'];
    promoStatusId = json['promoStatusId'];
    promoStatus = json['promoStatus'];
    discountPercentage = json['discountPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['typeOfCodeId'] = typeOfCodeId;
    data['typeOfCode'] = typeOfCode;
    data['startDate'] = startDate;
    data['expireDate'] = expireDate;
    data['promoStatusId'] = promoStatusId;
    data['promoStatus'] = promoStatus;
    data['discountPercentage'] = discountPercentage;
    return data;
  }
}
