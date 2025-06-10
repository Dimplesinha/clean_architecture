class BusinessListModel {
  int? statusCode;
  String? message;
  List<BusinessListResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  BusinessListModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  BusinessListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <BusinessListResult>[];
      json['result'].forEach((v) {
        result!.add(BusinessListResult.fromJson(v));
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

class BusinessListResult {
  int? businessProfileId;
  int? communityId;
  int? autoTypeId;
  String? businessName;
  String? title;
  String? autoTypeName;

  BusinessListResult({this.businessProfileId, this.businessName,this.title,this.communityId,this.autoTypeId,this.autoTypeName});

  BusinessListResult.fromJson(Map<String, dynamic> json) {
    businessProfileId = json['businessProfileId'];
    businessName = json['businessName'];
    communityId = json['communityId'];
    title = json['title'];
    autoTypeId = json['autoTypeId'];
    autoTypeName = json['autoTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['businessProfileId'] = businessProfileId;
    data['businessName'] = businessName;
    data['communityId'] = communityId;
    data['title'] = title;
    data['autoTypeName'] = autoTypeName;
    data['autoTypeId'] = autoTypeId;
    return data;
  }
}
