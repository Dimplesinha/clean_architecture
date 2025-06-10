class MasterDataModel {
  int? statusCode;
  String? message;
  List<MasterData>? masterData;
  bool? isSuccess;
  String? utcTimeStamp;

  MasterDataModel(
      {this.statusCode,
        this.message,
        this.masterData,
        this.isSuccess,
        this.utcTimeStamp});

  MasterDataModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      masterData = <MasterData>[];
      json['result'].forEach((v) {
        masterData!.add(MasterData.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (masterData != null) {
      data['result'] = masterData!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

class MasterData {
  String? uuid;
  int? communityListingTypeId;
  int? listingId;
  String? name;
  String? listingName;
  int? promoCategoryId;
  int? industryTypeId;
  int? skillId;
  String? promoCategoryName;
  String? skillName;
  String? industryTypeName;
  int? businessTypeId;
  String? businessTypeCode;
  String? businessTypeDesc;
  int? propertyTypeId;
  String? propertyTypeName;
  int? autoTypeId;
  String? autoTypeName;
  String? dateCreated;
  String? dateModified;

  MasterData(
      {this.uuid,
        this.communityListingTypeId,
        this.name,
        this.promoCategoryId,
        this.listingId,
        this.industryTypeId,
        this.skillId,
        this.promoCategoryName,
        this.listingName,
        this.skillName,
        this.industryTypeName,
        this.businessTypeId,
        this.businessTypeCode,
        this.businessTypeDesc,
        this.propertyTypeId,
        this.propertyTypeName,
        this.autoTypeId, this.autoTypeName,
        this.dateCreated,
        this.dateModified});

  MasterData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    communityListingTypeId = json['communityListingTypeId'];
    name = json['name'];
    promoCategoryId = json['promoCategoryId'];
    industryTypeId = json['industryTypeId'];
    skillId = json['skillId'];
    listingId = json['listingId'];
    skillName = json['skillName'];
    listingName = json['listingName'];
    promoCategoryName = json['promoCategoryName'];
    industryTypeName = json['industryTypeName'];
    businessTypeId = json['businessTypeId'];
    businessTypeCode = json['businessTypeCode'];
    businessTypeDesc = json['businessTypeDesc'];
    propertyTypeId = json['propertyTypeId'];
    propertyTypeName = json['propertyTypeName'];
    autoTypeId = json['autoTypeId'];
    autoTypeName = json['autoTypeName'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['communityListingTypeId'] = communityListingTypeId;
    data['name'] = name;
    data['promoCategoryId'] = promoCategoryId;
    data['industryTypeId'] = industryTypeId;
    data['skillId'] = skillId;
    data['listingId'] = listingId;
    data['listingName'] = listingName;
    data['skillName'] = skillName;
    data['promoCategoryName'] = promoCategoryName;
    data['industryTypeName'] = industryTypeName;
    data['businessTypeId'] = businessTypeId;
    data['businessTypeCode'] = businessTypeCode;
    data['businessTypeDesc'] = businessTypeDesc;
    data['propertyTypeId'] = propertyTypeId;
    data['propertyTypeName'] = propertyTypeName;
    data['autoTypeId'] = this.autoTypeId;
    data['autoTypeName'] = this.autoTypeName;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    return data;
  }
}
