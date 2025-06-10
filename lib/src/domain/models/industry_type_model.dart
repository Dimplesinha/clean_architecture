class IndustryTypeModel {
  int? statusCode;
  String? message;
  List<IndustryTypeResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  IndustryTypeModel({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  IndustryTypeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <IndustryTypeResult>[];
      json['result'].forEach((v) {
        result!.add(IndustryTypeResult.fromJson(v));
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

  List<String>? get getAllIndustry => result?.map((item) => item.industryTypeName as String).toList();
}

class IndustryTypeResult {
  int? industryTypeId;
  String? industryTypeName;
  int? diplayOrder;
  String? uuid;

  IndustryTypeResult({this.industryTypeId, this.industryTypeName, this.diplayOrder, this.uuid});

  IndustryTypeResult.fromJson(Map<String, dynamic> json) {
    industryTypeId = json['industryTypeId'];
    industryTypeName = json['industryTypeName'];
    diplayOrder = json['diplayOrder'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['industryTypeId'] = industryTypeId;
    data['industryTypeName'] = industryTypeName;
    data['diplayOrder'] = diplayOrder;
    data['uuid'] = uuid;
    return data;
  }
}
