class AutoTypeResponse {
  int? statusCode;
  String? message;
  List<AutoTypeList>? autoTypeList;
  bool? isSuccess;
  String? utcTimeStamp;

  AutoTypeResponse(
      {this.statusCode,
        this.message,
        this.autoTypeList,
        this.isSuccess,
        this.utcTimeStamp});

  AutoTypeResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      autoTypeList = <AutoTypeList>[];
      json['result'].forEach((v) {
        autoTypeList!.add(AutoTypeList.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (autoTypeList != null) {
      data['result'] = autoTypeList!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

class AutoTypeList {
  int? autoTypeId;
  String? autoTypeName;
  String? autoTypeDesc;
  int? autoTypeOrder;
  String? uuid;

  AutoTypeList(
      {this.autoTypeId,
        this.autoTypeName,
        this.autoTypeDesc,
        this.autoTypeOrder,
        this.uuid});

  AutoTypeList.fromJson(Map<String, dynamic> json) {
    autoTypeId = json['autoTypeId'];
    autoTypeName = json['autoTypeName'];
    autoTypeDesc = json['autoTypeDesc'];
    autoTypeOrder = json['autoTypeOrder'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['autoTypeId'] = autoTypeId;
    data['autoTypeName'] = autoTypeName;
    data['autoTypeDesc'] = autoTypeDesc;
    data['autoTypeOrder'] = autoTypeOrder;
    data['uuid'] = uuid;
    return data;
  }
}
