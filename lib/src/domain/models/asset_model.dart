class IconModel {
  int? statusCode;
  String? message;
  List<IconDataModel>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  IconModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  IconModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <IconDataModel>[];
      json['result'].forEach((v) {
        result!.add(IconDataModel.fromJson(v));
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

class IconDataModel {
  int? assetTypeId;
  String? assetType;
  String? assetTitle;
  String? fileName;
  String? fileDescription;
  String? fileUrl;

  IconDataModel(
      {this.assetTypeId,
        this.assetType,
        this.assetTitle,
        this.fileName,
        this.fileDescription,
        this.fileUrl});

  IconDataModel.fromJson(Map<String, dynamic> json) {
    assetTypeId = json['assetTypeId'];
    assetType = json['assetType'];
    assetTitle = json['assetTitle'];
    fileName = json['fileName'];
    fileDescription = json['fileDescription'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assetTypeId'] = assetTypeId;
    data['assetType'] = assetType;
    data['assetTitle'] = assetTitle;
    data['fileName'] = fileName;
    data['fileDescription'] = fileDescription;
    data['fileUrl'] = fileUrl;
    return data;
  }
}
