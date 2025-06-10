///
/// @AUTHOR : Mac OS
/// @DATE : 18/11/24
/// @Message :
///
/// 
class CurrencyResponseModel {
  int? statusCode;
  String? message;
  List<CurrencyResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  CurrencyResponseModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  CurrencyResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CurrencyResult>[];
      json['result'].forEach((v) {
        result!.add( CurrencyResult.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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

class CurrencyResult {
  int? count;
  List<CurrencyModel>? items;

  CurrencyResult({this.count, this.items});

  CurrencyResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <CurrencyModel>[];
      json['items'].forEach((v) {
        items!.add( CurrencyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['count'] = count;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyModel {
  String? currencyName;
  String? currencySymbol;
  String? currencyCode;
  String? uuid;

  CurrencyModel({this.currencyName, this.currencySymbol, this.currencyCode, this.uuid});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    currencyName = json['currencyName'];
    currencySymbol = json['currencySymbol'];
    currencyCode = json['currencyCode'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['currencyName'] = currencyName;
    data['currencySymbol'] = currencySymbol;
    data['currencyCode'] = currencyCode;
    data['uuid'] = uuid;
    return data;
  }
}
