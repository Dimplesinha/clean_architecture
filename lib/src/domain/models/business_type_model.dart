class BusinessTypeModel {
  int? statusCode;
  String? message;
  List<BusinessTypeResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  BusinessTypeModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  BusinessTypeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <BusinessTypeResult>[];
      json['result'].forEach((v) {
        result!.add(BusinessTypeResult.fromJson(v));
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

class BusinessTypeResult {
  String? uuid;
  int? businessTypeId;
  String? businessTypeCode;
  String? businessTypeDesc;
  String? dateCreated;
  String? dateModified;

  BusinessTypeResult({
    this.uuid,
    this.businessTypeId,
    this.businessTypeCode,
    this.businessTypeDesc,
    this.dateCreated,
    this.dateModified,
  });

  BusinessTypeResult.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    businessTypeId = json['businessTypeId'];
    businessTypeCode = json['businessTypeCode'];
    businessTypeDesc = json['businessTypeDesc'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['businessTypeId'] = businessTypeId;
    data['businessTypeCode'] = businessTypeCode;
    data['businessTypeDesc'] = businessTypeDesc;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    return data;
  }
}
