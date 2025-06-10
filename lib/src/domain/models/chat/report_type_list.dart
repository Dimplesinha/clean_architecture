class ReportTypeModel {
  int? statusCode;
  String? message;
  List<ReportTypeModelList>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ReportTypeModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  ReportTypeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <ReportTypeModelList>[];
      json['result'].forEach((v) {
        result!.add(ReportTypeModelList.fromJson(v));
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

class ReportTypeModelList {
  int? reportTypeId;
  String? reportType;
  String? dateCreated;
  String? dateModified;
  String? uuid;

  ReportTypeModelList(
      {this.reportTypeId,
        this.reportType,
        this.dateCreated,
        this.dateModified,
        this.uuid});

  ReportTypeModelList.fromJson(Map<String, dynamic> json) {
    reportTypeId = json['reportTypeId'];
    reportType = json['reportType'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reportTypeId'] = reportTypeId;
    data['reportType'] = reportType;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['uuid'] = uuid;
    return data;
  }
}
