class PropertyTypeModel {
  int? statusCode;
  String? message;
  List<PropertyTypeResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  PropertyTypeModel({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <PropertyTypeResult>[];
      json['result'].forEach((v) {
        result!.add(PropertyTypeResult.fromJson(v));
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

  List<String>? get getPropertyTypeList => result?.map((item) => item.propertyTypeName as String).toList();
}

class PropertyTypeResult {
  String? uuid;
  int? propertyTypeId;
  String? propertyTypeName;
  int? displayOrder;
  String? dateCreated;
  String? dateModified;

  PropertyTypeResult(
      {this.uuid, this.propertyTypeId, this.propertyTypeName, this.displayOrder, this.dateCreated, this.dateModified});

  PropertyTypeResult.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    propertyTypeId = json['propertyTypeId'];
    propertyTypeName = json['propertyTypeName'];
    displayOrder = json['displayOrder'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['propertyTypeId'] = propertyTypeId;
    data['propertyTypeName'] = propertyTypeName;
    data['displayOrder'] = displayOrder;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    return data;
  }
}
