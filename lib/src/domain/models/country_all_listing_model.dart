import 'package:workapp/src/utils/date_time_utils.dart';

class CountryAllListing {
  int? statusCode;
  String? message;
  List<Countries>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  CountryAllListing(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  CountryAllListing.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Countries>[];
      json['result'].forEach((v) {
        result!.add(Countries.fromJson(v));
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

  String getCountryLoadedDate() {
    DateTime tmp = DateTimeUtils.instance.stringToDateInLocal(string: utcTimeStamp.toString());

    return DateTimeUtils.instance.timeStampToDateOnly(tmp);
  }
}

class Countries {
  int? countryId;
  String? countryName;
  String? countryCode;
  String? countryPhoneCode;
  String? currencyName;
  String? currencyCode;
  String? currencySymbol;
  int? minLength;
  int? maxLength;
  String? uuid;

  Countries(
      {this.countryId,
        this.countryName,
        this.countryCode,
        this.countryPhoneCode,
        this.currencyName,
        this.currencyCode,
        this.currencySymbol,
        this.minLength,
        this.maxLength,
        this.uuid});

  Countries.fromJson(Map<String, dynamic> json) {
    countryId = json['countryId'];
    countryName = json['country'];
    countryCode = json['countryCode'];
    countryPhoneCode = json['countryPhoneCode'];
    currencyName = json['currencyName'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryId'] = countryId;
    data['country'] = countryName;
    data['countryCode'] = countryCode;
    data['countryPhoneCode'] = countryPhoneCode;
    data['currencyName'] = currencyName;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    data['minLength'] = minLength;
    data['maxLength'] = maxLength;
    data['uuid'] = uuid;
    return data;
  }
}