/*
class JobsAddListingResponse {
  int? statusCode;
  String? message;
  JobsAddListingModel? result;
  bool? isSuccess;
  String? utcTimeStamp;

  JobsAddListingResponse({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  JobsAddListingResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? JobsAddListingModel.fromJson(json['result']) : null;
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

class JobsAddListingModel {
  int? jobId;
  int? businessProfileId;
  String? businessName;
  int? communityId;
  String? jobTitle;
  String? userName;
  String? userUUID;
  int? accountType;
  String? description;
  String? docFile;
  int? priceFrom;
  int? priceTo;
  String? endDate;
  String? endTime;
  String? currency;
  int? duration;
  int? visibilityType;
  String? city;
  String? state;
  String? country;
  String? countryCode;
  String? countryPhoneCode;
  String? address;
  bool? isShowStreetAddress;
  String? contactName;
  String? contactEmail;
  String? contactPhone;
  String? webSite;
  String? recordStatus;
  bool? isTrustedUser;
  String? jobLogo;
  int? latitude;
  int? longitude;
  String? location;
  List<JobListingImages>? images;
  List<JobRequirements>? jobRequirements;
  int? totalLikeCount;
  bool? selfBookMark;
  bool? selfLike;
  String? dateCreated;
  String? dateModified;
  String? uuid;

  JobsAddListingModel(
      {this.jobId,
      this.businessProfileId,
      this.businessName,
      this.communityId,
      this.jobTitle,
      this.userName,
      this.userUUID,
      this.accountType,
      this.description,
      this.docFile,
      this.priceFrom,
      this.priceTo,
      this.endDate,
      this.endTime,
      this.currency,
      this.duration,
      this.visibilityType,
      this.city,
      this.state,
      this.country,
      this.countryCode,
      this.countryPhoneCode,
      this.address,
      this.isShowStreetAddress,
      this.contactName,
      this.contactEmail,
      this.contactPhone,
      this.webSite,
      this.recordStatus,
      this.isTrustedUser,
      this.jobLogo,
      this.latitude,
      this.longitude,
      this.location,
      this.images,
      this.jobRequirements,
      this.totalLikeCount,
      this.selfBookMark,
      this.selfLike,
      this.dateCreated,
      this.dateModified,
      this.uuid});

  JobsAddListingModel.fromJson(Map<String, dynamic> json) {
    jobId = json['jobId'];
    businessProfileId = json['businessProfileId'];
    businessName = json['businessName'];
    communityId = json['communityId'];
    jobTitle = json['jobTitle'];
    userName = json['userName'];
    userUUID = json['userUUID'];
    accountType = json['accountType'];
    description = json['description'];
    docFile = json['docFile'];
    priceFrom = json['priceFrom'];
    priceTo = json['priceTo'];
    endDate = json['endDate'];
    endTime = json['endTime'];
    currency = json['currency'];
    duration = json['duration'];
    visibilityType = json['visibilityType'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    countryCode = json['countryCode'];
    countryPhoneCode = json['countryPhoneCode'];
    address = json['address'];
    isShowStreetAddress = json['isShowStreetAddress'];
    contactName = json['contactName'];
    contactEmail = json['contactEmail'];
    contactPhone = json['contactPhone'];
    webSite = json['webSite'];
    recordStatus = json['recordStatus'];
    isTrustedUser = json['isTrustedUser'];
    jobLogo = json['jobLogo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    if (json['images'] != null) {
      images = <JobListingImages>[];
      json['images'].forEach((v) {
        images!.add(JobListingImages.fromJson(v));
      });
    }
    if (json['jobRequirements'] != null) {
      jobRequirements = <JobRequirements>[];
      json['jobRequirements'].forEach((v) {
        jobRequirements!.add(JobRequirements.fromJson(v));
      });
    }
    totalLikeCount = json['totalLikeCount'];
    selfBookMark = json['selfBookMark'];
    selfLike = json['selfLike'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jobId'] = jobId;
    data['businessProfileId'] = businessProfileId;
    data['businessName'] = businessName;
    data['communityId'] = communityId;
    data['jobTitle'] = jobTitle;
    data['userName'] = userName;
    data['userUUID'] = userUUID;
    data['accountType'] = accountType;
    data['description'] = description;
    data['docFile'] = docFile;
    data['priceFrom'] = priceFrom;
    data['priceTo'] = priceTo;
    data['endDate'] = endDate;
    data['endTime'] = endTime;
    data['currency'] = currency;
    data['duration'] = duration;
    data['visibilityType'] = visibilityType;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['countryCode'] = countryCode;
    data['countryPhoneCode'] = countryPhoneCode;
    data['address'] = address;
    data['isShowStreetAddress'] = isShowStreetAddress;
    data['contactName'] = contactName;
    data['contactEmail'] = contactEmail;
    data['contactPhone'] = contactPhone;
    data['webSite'] = webSite;
    data['recordStatus'] = recordStatus;
    data['isTrustedUser'] = isTrustedUser;
    data['jobLogo'] = jobLogo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['location'] = location;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (jobRequirements != null) {
      data['jobRequirements'] = jobRequirements!.map((v) => v.toJson()).toList();
    }
    data['totalLikeCount'] = totalLikeCount;
    data['selfBookMark'] = selfBookMark;
    data['selfLike'] = selfLike;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['uuid'] = uuid;
    return data;
  }
}

class JobRequirements {
  int? jobRequirementId;
  String? jobRequirement;
  int? displayOrder;

  JobRequirements({this.jobRequirementId, this.jobRequirement, this.displayOrder});

  JobRequirements.fromJson(Map<String, dynamic> json) {
    jobRequirementId = json['jobRequirementId'];
    jobRequirement = json['jobRequirement'];
    displayOrder = json['displayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jobRequirementId'] = jobRequirementId;
    data['jobRequirement'] = jobRequirement;
    data['displayOrder'] = displayOrder;
    return data;
  }
}

class JobListingImages {
  int? jobImagesId;
  String? fileName;
  String? fileLocalPath;
  int? fileType;
  int? displayOrder;
  int? displayOrderOldIndex;

  JobListingImages({this.jobImagesId, this.fileName, this.fileType, this.displayOrder, this.fileLocalPath, this.displayOrderOldIndex});

  JobListingImages.fromJson(Map<String, dynamic> json) {
    jobImagesId = json['jobImagesId'];
    fileName = json['fileName'];
    fileType = json['fileType'];
    displayOrder = json['displayOrder'];
    fileLocalPath = json['fileLocalPath'];
    displayOrderOldIndex = json['displayOrderOldIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jobImagesId'] = jobImagesId;
    data['fileName'] = fileName;
    data['fileType'] = fileType;
    data['displayOrder'] = displayOrder;
    data['fileLocalPath'] = fileLocalPath;
    data['displayOrderOldIndex'] = displayOrderOldIndex;
    return data;
  }
}
*/
