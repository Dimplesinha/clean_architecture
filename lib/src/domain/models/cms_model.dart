/// Created by
/// @AUTHOR : Prakash Software Solution Pvt. Ltd.
/// @DATE : 20-09-2024
/// @Message :

class CMSTypeModel {
  int? statusCode;
  String? message;
  CMSData? result;
  bool? isSuccess;
  String? utcTimeStamp;

  CMSTypeModel({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  CMSTypeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? CMSData.fromJson(json['result']) : null;
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

class CMSData {
  int? cmsId;
  int? cmsTypeId;
  String? title;
  String? description;
  String? recordStatus;
  String? dateCreated;
  String? dateModified;

  CMSData(
      {this.cmsId,
      this.cmsTypeId,
      this.title,
      this.description,
      this.recordStatus,
      this.dateCreated,
      this.dateModified});

  CMSData.fromJson(Map<String, dynamic> json) {
    cmsId = json['cmsId'];
    cmsTypeId = json['cmsTypeId'];
    title = json['title'];
    description = json['description'];
    recordStatus = json['recordStatus'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cmsId'] = cmsId;
    data['cmsTypeId'] = cmsTypeId;
    data['title'] = title;
    data['description'] = description;
    data['recordStatus'] = recordStatus;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    return data;
  }
}
