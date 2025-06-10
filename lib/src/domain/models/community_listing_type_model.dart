class CommunityListingTypeModel {
  int? statusCode;
  String? message;
  List<CommunityListingTypeResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  CommunityListingTypeModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  CommunityListingTypeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CommunityListingTypeResult>[];
      json['result'].forEach((v) {
        result!.add(CommunityListingTypeResult.fromJson(v));
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

class CommunityListingTypeResult {
  String? uuid;
  int? communityListingTypeId;
  String? name;
  String? dateCreated;
  String? dateModified;

  CommunityListingTypeResult({
    this.uuid,
    this.communityListingTypeId,
    this.name,
    this.dateCreated,
    this.dateModified,
  });

  CommunityListingTypeResult.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    communityListingTypeId = json['communityListingTypeId'];
    name = json['name'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['communityListingTypeId'] = communityListingTypeId;
    data['name'] = name;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    return data;
  }
}
