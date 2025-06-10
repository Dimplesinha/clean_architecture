// import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
//
// class BusinessAddListingModel {
//   int? statusCode;
//   String? message;
//   BusinessProfileModel? result;
//   bool? isSuccess;
//   String? utcTimeStamp;
//
//   BusinessAddListingModel({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});
//
//   BusinessAddListingModel.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     message = json['message'];
//     result = json['result'] != null ? BusinessProfileModel.fromJson(json['result']) : null;
//     isSuccess = json['isSuccess'];
//     utcTimeStamp = json['utcTimeStamp'];
//   }
// }
//
// class BusinessProfileModel {
//   String? uuid;
//   String? dateCreated;
//   String? dateModified;
//   int? businessProfileId;
//   int? businessTypeId;
//   int? jobId;
//   int? communityId;
//   String? jobTitle;
//   String? docFile;
//   double? priceFrom;
//   double? priceTo;
//   String? endDate;
//   String? endTime;
//   String? currency;
//   int? duration;
//   String? jobLogo;
//   String? businessTypeTitle;
//   String? userName;
//   String? userUUID;
//   String? businessName;
//   String? description;
//   String? registrationNumber;
//   String? businessTypeCode;
//   String? city;
//   String? state;
//   String? countryCode;
//   String? countryPhoneCode;
//   String? country;
//   String? address;
//   String? email;
//   String? webSite;
//   String? phone;
//   int? visibilityType;
//   bool? isShowStreetAddress;
//   String? businessLogo;
//   String? recordStatus;
//   List<BusinessImagesModel>? images;
//   bool? isTrustedUser;
//   double? latitude;
//   double? longitude;
//   String? location;
//   int? accountType;
//   int? promoId;
//   String? promoName;
//   String? promoStartDate;
//   String? promoEndDate;
//   String? promoURL;
//   String? promoLogo;
//   String? contactName;
//   String? contactEmail;
//   String? contactPhone;
//   bool? selfBookmark;
//   bool? selfLike;
//   int? totalLikeCount;
//   List<JobRequirements>? jobRequirements;
//   bool? selfBookMark;
//
//   BusinessProfileModel({
//     this.uuid,
//     this.dateCreated,
//     this.dateModified,
//     this.businessProfileId,
//     this.businessTypeId,
//     this.businessTypeTitle,
//     this.userName,
//     this.userUUID,
//     this.businessName,
//     this.description,
//     this.registrationNumber,
//     this.businessTypeCode,
//     this.city,
//     this.state,
//     this.countryCode,
//     this.countryPhoneCode,
//     this.country,
//     this.address,
//     this.email,
//     this.webSite,
//     this.phone,
//     this.visibilityType,
//     this.isShowStreetAddress,
//     this.businessLogo,
//     this.recordStatus,
//     this.images,
//     this.isTrustedUser,
//     this.latitude,
//     this.longitude,
//     this.location,
//     this.accountType,
//     this.promoId,
//     this.communityId,
//     this.promoName,
//     this.promoStartDate,
//     this.promoEndDate,
//     this.promoURL,
//     this.promoLogo,
//     this.contactName,
//     this.contactEmail,
//     this.contactPhone,
//     this.selfBookmark,
//     this.selfLike,
//     this.totalLikeCount,
//     this.jobId,
//     this.jobTitle,
//     this.docFile,
//     this.priceFrom,
//     this.priceTo,
//     this.endDate,
//     this.endTime,
//     this.currency,
//     this.duration,
//     this.jobLogo,
//     this.jobRequirements,
//     this.selfBookMark,
//   });
//
//   BusinessProfileModel.fromJson(Map<String, dynamic> json) {
//     uuid = json['uuid'];
//     dateCreated = json['dateCreated'];
//     dateModified = json['dateModified'];
//     businessProfileId = json['businessProfileId'];
//     businessTypeId = json['businessTypeId'];
//     businessTypeTitle = json['businessTypeTitle'];
//     userName = json['userName'];
//     jobId = json['jobId'];
//     communityId = json['communityId'];
//     jobTitle = json['jobTitle'];
//     userUUID = json['userUUID'];
//     businessName = json['businessName'];
//     description = json['description'];
//     registrationNumber = json['registrationNumber'];
//     businessTypeCode = json['businessTypeCode'];
//     city = json['city'];
//     state = json['state'];
//     countryCode = json['countryCode'];
//     countryPhoneCode = json['countryPhoneCode'];
//     country = json['country'];
//     address = json['address'];
//     email = json['email'];
//     webSite = json['webSite'];
//     phone = json['phone'];
//     visibilityType = json['visibilityType'];
//     docFile = json['docFile'];
//     priceFrom = json['priceFrom'];
//     priceTo = json['priceTo'];
//     endDate = json['endDate'];
//     endTime = json['endTime'];
//     currency = json['currency'];
//     duration = json['duration'];
//     jobLogo = json['jobLogo'];
//     isShowStreetAddress = json['isShowStreetAddress'];
//     businessLogo = json['businessLogo'];
//     recordStatus = json['recordStatus'];
//     if (json['images'] != null) {
//       images = <BusinessImagesModel>[];
//       json['images'].forEach((v) {
//         images!.add(BusinessImagesModel.fromJson(v));
//       });
//     }
//     if (json['jobRequirements'] != null) {
//       jobRequirements = <JobRequirements>[];
//       json['jobRequirements'].forEach((v) {
//         jobRequirements!.add(JobRequirements.fromJson(v));
//       });
//     }
//     isTrustedUser = json['isTrustedUser'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     location = json['location'];
//     accountType = json['accountType'];
//     promoId = json['promoId'];
//     communityId = json['communityId'];
//     promoName = json['promoName'];
//     promoStartDate = json['promoStartDate'];
//     promoEndDate = json['promoEndDate'];
//     promoURL = json['promoURL'];
//     promoLogo = json['promoLogo'];
//     contactName = json['contactName'];
//     contactEmail = json['contactEmail'];
//     contactPhone = json['contactPhone'];
//     selfBookmark = json['selfBookmark'];
//     selfLike = json['selfLike'];
//     totalLikeCount = json['totalLikeCount'];
//     totalLikeCount = json['totalLikeCount'];
//     selfBookMark = json['selfBookMark'];
//     selfLike = json['selfLike'];
//   }
//
//
// }
//
// import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
//
// class BusinessAddListingModel {
//   int? statusCode;
//   String? message;
//   BusinessProfileModel? result;
//   bool? isSuccess;
//   String? utcTimeStamp;
//
//   BusinessAddListingModel({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});
//
//   BusinessAddListingModel.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     message = json['message'];
//     result = json['result'] != null ? BusinessProfileModel.fromJson(json['result']) : null;
//     isSuccess = json['isSuccess'];
//     utcTimeStamp = json['utcTimeStamp'];
//   }
// }
// class BusinessProfileModel {
//   // Common Fields
//   String? uuid;
//   String? dateCreated;
//   String? dateModified;
//   int? businessProfileId;
//   int? classifiedId;
//   int? businessTypeId;
//   String? businessTypeTitle;
//   String? userName;
//   String? userUUID;
//   String? businessName;
//   String? description;
//   String? registrationNumber;
//   String? businessTypeCode;
//   String? city;
//   String? state;
//   String? countryCode;
//   String? countryPhoneCode;
//   String? country;
//   String? address;
//   String? email;
//   String? webSite;
//   String? phone;
//   int? visibilityType;
//   bool? isShowStreetAddress;
//   String? businessLogo;
//   String? recordStatus;
//   List<BusinessImagesModel>? images;
//   bool? isTrustedUser;
//   double? latitude;
//   double? longitude;
//   String? location;
//   int? accountType;
//   int? promoId;
//   int? communityId;
//   String? promoName;
//   String? promoStartDate;
//   String? promoEndDate;
//   String? promoURL;
//   String? promoLogo;
//   String? contactName;
//   String? contactEmail;
//   String? contactPhone;
//   bool? selfBookmark;
//   bool? selfLike;
//   int? totalLikeCount;
//
//   // Worker-Specific Fields
//   int? workerId;
//   int? skillId;
//   String? workerName;
//   String? skillName;
//   int? distanceKm;
//   String? radiusId;
//   String? radiusName;
//   String? cvFile;
//   String? workerLogo;
//   List<String>? skills;
//
//   BusinessProfileModel({
//     // Common Fields
//     this.uuid,
//     this.dateCreated,
//     this.dateModified,
//     this.businessProfileId,
//     this.businessTypeId,
//     this.businessTypeTitle,
//     this.userName,
//     this.userUUID,
//     this.businessName,
//     this.description,
//     this.registrationNumber,
//     this.businessTypeCode,
//     this.city,
//     this.state,
//     this.countryCode,
//     this.countryPhoneCode,
//     this.country,
//     this.address,
//     this.email,
//     this.webSite,
//     this.phone,
//     this.visibilityType,
//     this.isShowStreetAddress,
//     this.businessLogo,
//     this.recordStatus,
//     this.images,
//     this.isTrustedUser,
//     this.latitude,
//     this.longitude,
//     this.location,
//     this.accountType,
//     this.promoId,
//     this.communityId,
//     this.promoName,
//     this.promoStartDate,
//     this.promoEndDate,
//     this.promoURL,
//     this.promoLogo,
//     this.contactName,
//     this.contactEmail,
//     this.contactPhone,
//     this.selfBookmark,
//     this.selfLike,
//     this.totalLikeCount,
//     // Worker-Specific Fields
//     this.workerId,
//     this.skillId,
//     this.workerName,
//     this.skillName,
//     this.distanceKm,
//     this.radiusId,
//     this.radiusName,
//     this.cvFile,
//     this.workerLogo,
//     this.skills,
//     this.classifiedId,
//   });
//
//
//   BusinessProfileModel.fromJson(Map<String, dynamic> json) {
//     // Common Fields
//     uuid = json['uuid'];
//     classifiedId = json['classifiedId'];
//     dateCreated = json['dateCreated'];
//     dateModified = json['dateModified'];
//     businessProfileId = json['businessProfileId'];
//     businessTypeId = json['businessTypeId'];
//     businessTypeTitle = json['businessTypeTitle'];
//     userName = json['userName'];
//     userUUID = json['userUUID'];
//     businessName = json['businessName'];
//     description = json['description'];
//     registrationNumber = json['registrationNumber'];
//     businessTypeCode = json['businessTypeCode'];
//     city = json['city'];
//     state = json['state'];
//     countryCode = json['countryCode'];
//     countryPhoneCode = json['countryPhoneCode'];
//     country = json['country'];
//     address = json['address'];
//     email = json['email'];
//     webSite = json['webSite'];
//     phone = json['phone'];
//     visibilityType = json['visibilityType'];
//     isShowStreetAddress = json['isShowStreetAddress'];
//     businessLogo = json['businessLogo'];
//     recordStatus = json['recordStatus'];
//     if (json['images'] != null) {
//       images = <BusinessImagesModel>[];
//       json['images'].forEach((v) {
//         images!.add(BusinessImagesModel.fromJson(v));
//       });
//     }
//     isTrustedUser = json['isTrustedUser'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     location = json['location'];
//     accountType = json['accountType'];
//     promoId = json['promoId'];
//     communityId = json['communityId'];
//     promoName = json['promoName'];
//     promoStartDate = json['promoStartDate'];
//     promoEndDate = json['promoEndDate'];
//     promoURL = json['promoURL'];
//     promoLogo = json['promoLogo'];
//     contactName = json['contactName'];
//     contactEmail = json['contactEmail'];
//     contactPhone = json['contactPhone'];
//     selfBookmark = json['selfBookmark'];
//     selfLike = json['selfLike'];
//     totalLikeCount = json['totalLikeCount'];
//
//     // Worker-Specific Fields
//     workerId = json['workerId'];
//     skillId = json['skillId'];
//     workerName = json['workerName'];
//     skillName = json['skillName'];
//     distanceKm = json['distanceKm'];
//     radiusId = json['radiusId'];
//     radiusName = json['radiusName'];
//     cvFile = json['cvFile'];
//     workerLogo = json['workerLogo'];
//     skills = json['skills']?.cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     // Common Fields
//     data['uuid'] = uuid;
//     data['dateCreated'] = dateCreated;
//     data['dateModified'] = dateModified;
//     data['businessProfileId'] = businessProfileId;
//     data['businessTypeId'] = businessTypeId;
//     data['businessTypeTitle'] = businessTypeTitle;
//     data['userName'] = userName;
//     data['userUUID'] = userUUID;
//     data['businessName'] = businessName;
//     data['description'] = description;
//     data['registrationNumber'] = registrationNumber;
//     data['businessTypeCode'] = businessTypeCode;
//     data['city'] = city;
//     data['state'] = state;
//     data['countryCode'] = countryCode;
//     data['countryPhoneCode'] = countryPhoneCode;
//     data['country'] = country;
//     data['address'] = address;
//     data['email'] = email;
//     data['webSite'] = webSite;
//     data['phone'] = phone;
//     data['visibilityType'] = visibilityType;
//     data['isShowStreetAddress'] = isShowStreetAddress;
//     data['businessLogo'] = businessLogo;
//     data['recordStatus'] = recordStatus;
//     if (images != null) {
//       data['images'] = images!.map((v) => v.toJson()).toList();
//     }
//     data['isTrustedUser'] = isTrustedUser;
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     data['location'] = location;
//     data['accountType'] = accountType;
//     data['promoId'] = promoId;
//     data['communityId'] = communityId;
//     data['promoName'] = promoName;
//     data['promoStartDate'] = promoStartDate;
//     data['promoEndDate'] = promoEndDate;
//     data['promoURL'] = promoURL;
//     data['promoLogo'] = promoLogo;
//     data['contactName'] = contactName;
//     data['contactEmail'] = contactEmail;
//     data['contactPhone'] = contactPhone;
//     data['selfBookmark'] = selfBookmark;
//     data['selfLike'] = selfLike;
//     data['totalLikeCount'] = totalLikeCount;
//
//     // Worker-Specific Fields
//     data['workerId'] = workerId;
//     data['skillId'] = skillId;
//     data['workerName'] = workerName;
//     data['skillName'] = skillName;
//     data['distanceKm'] = distanceKm;
//     data['radiusId'] = radiusId;
//     data['radiusName'] = radiusName;
//     data['cvFile'] = cvFile;
//     data['workerLogo'] = workerLogo;
//     data['skills'] = skills;
//     return data;
//   }
// }
