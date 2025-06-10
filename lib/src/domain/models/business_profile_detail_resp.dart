import 'package:workapp/src/domain/models/worker_skills_model.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';

class BusinessProfileDetailResponse {
  int? statusCode;
  String? message;
  BusinessProfileModel? businessProfileModel;
  bool? isSuccess;
  String? utcTimeStamp;

  BusinessProfileDetailResponse(
      {this.statusCode, this.message, this.businessProfileModel, this.isSuccess, this.utcTimeStamp});

  BusinessProfileDetailResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    businessProfileModel = json['result'] != null ? BusinessProfileModel.fromJson(json['result']) : null;
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (businessProfileModel != null) {
      data['result'] = businessProfileModel!.toJson();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

class BusinessProfileModel {
  bool? isPremiumUserListing;
  int? businessProfileId;
  int? businessTypeId;
  String? itemName;
  String? itemDescription;
  double? price;
  String? currency;
  int? classifiedType;
  int? classifiedId;
  int? communityId;
  String? communityName;
  String? productSellURL;
  String? contactName;
  String? contactEmail;
  String? contactPhone;
  int? jobId;
  String? businessTypeTitle;
  String? jobTitle;
  String? userName;
  String? userUUID;
  String? businessName;
  String? description;
  String? docFile;
  String? registrationNumber;
  String? businessTypeCode;
  String? city;
  String? state;
  String? countryCode;
  String? countryPhoneCode;
  String? country;
  String? address;
  String? email;
  String? webSite;
  String? phone;
  int? visibilityType;
  bool? isShowStreetAddress;
  String? businessLogo;
  String? classifiedLogo;
  String? recordStatus;
  List<BusinessImagesModel>? images;
  List<JobRequirements>? jobRequirements;
  bool? isTrustedUser;
  double? latitude;
  double? longitude;
  String? location;
  int? accountType;
  String? dateCreated;
  String? boostDate;
  String? dateModified;
  double? priceFrom;
  double? priceTo;
  String? endDate;
  String? endTime;
  int? duration;
  String? jobLogo;
  String? uuid;
  int? promoId;
  int? promoCategoryId;
  String? promoCategoryName;
  int? industryTypeId;
  String? industryTypeName;
  String? promoName;
  String? promoStartDate;
  String? promoEndDate;
  String? promoURL;
  String? promoLogo;
  bool? selfBookmark;
  bool? selfLike;
  int? totalLikeCount;
  int? totalReviewCount;
  bool? selfBookMark;
  bool? selfReview;

  // Worker-Specific Fields
  int? workerId;
  int? skillId;
  String? workerName;
  String? skillName;
  double? distanceKm;
  int? radiusId;
  String? radiusName;
  String? cvFile;
  String? workerLogo;
  List<WorkerSkillsResult>? skills;

  // Community Fields
  int? communityTypeId;
  int? communityListingTypeId;
  String? communityListingType;
  String? title;
  String? otherListingType;
  String? otherSkill;
  String? phoneDialCode;
  String? phoneCountryCode;
  String? communityLogo;

  // Auto Field
  int? autoId;
  int? autoType;
  String? autoTypeName;
  String? autoTitle;
  bool? autoRegistered;
  String? autoRegistrationNumber;
  String? autoDescription;
  String? autoYear;
  int? autoSaleType;
  int? vehicleCondition;
  int? paymentInterval;
  double? avgRating;
  String? autoLogo;

  // real Estate Fields
  int? realEstateId;
  int? saleTypeId;
  int? costTypeId;
  int? inSpectionTypeId;
  String? inSpectionDate;
  String? inSpectionStartTime;
  String? inSpectionEndTime;
  String? auctionDate;
  String? auctionTime;
  bool? petsAllowed;
  String? bondDeposit;
  double? rentalCostFrom;
  double? rentalCostTo;
  int? bed;
  int? bath;
  int? garage;
  int? pool;
  String? landSize;
  int? landUnitsofMeasure;
  String? buildingSize;
  int? buildingUnitsofMeasure;
  String? saleType;
  String? costType;
  String? inSpectionType;
  int? propertyTypeId;
  String? propertyTypeName;
  MyRating? myRating;
  String? businessWebsite;
  String? realEstateLogo;
  bool? spam;

  BusinessProfileModel({
    this.itemName,
    this.itemDescription,
    this.price,
    this.currency,
    this.classifiedType,
    this.classifiedId,
    this.communityId,
    this.communityName,
    this.productSellURL,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.businessProfileId,
    this.classifiedLogo,
    this.businessTypeId,
    this.businessTypeTitle,
    this.industryTypeName,
    this.userName,
    this.userUUID,
    this.businessName,
    this.description,
    this.registrationNumber,
    this.businessTypeCode,
    this.city,
    this.state,
    this.countryCode,
    this.countryPhoneCode,
    this.country,
    this.address,
    this.email,
    this.webSite,
    this.phone,
    this.visibilityType,
    this.isShowStreetAddress,
    this.businessLogo,
    this.recordStatus,
    this.images,
    this.isTrustedUser,
    this.latitude,
    this.longitude,
    this.location,
    this.accountType,
    this.dateCreated,
    this.boostDate,
    this.dateModified,
    this.uuid,
    this.promoId,
    this.promoCategoryId,
    this.promoCategoryName,
    this.industryTypeId,
    this.promoName,
    this.promoStartDate,
    this.promoEndDate,
    this.promoURL,
    this.promoLogo,
    this.selfBookmark,
    this.selfLike,
    this.totalLikeCount,
    this.workerId,
    this.skillId,
    this.workerName,
    this.skillName,
    this.distanceKm,
    this.radiusId,
    this.radiusName,
    this.cvFile,
    this.workerLogo,
    this.skills,
    this.selfBookMark,
    this.jobId,
    this.jobTitle,
    this.docFile,
    this.priceFrom,
    this.priceTo,
    this.endDate,
    this.endTime,
    this.duration,
    this.jobLogo,
    this.communityTypeId,
    this.title,
    this.communityListingTypeId,
    this.communityListingType,
    this.otherListingType,
    this.otherSkill,
    this.phoneDialCode,
    this.phoneCountryCode,
    this.communityLogo,
    this.autoId,
    this.autoType,
    this.autoTypeName,
    this.autoTitle,
    this.autoRegistered,
    this.autoRegistrationNumber,
    this.autoDescription,
    this.autoYear,
    this.autoSaleType,
    this.vehicleCondition,
    this.paymentInterval,
    this.avgRating,
    this.selfReview,
    this.totalReviewCount,
    this.realEstateId,
    this.saleTypeId,
    this.costTypeId,
    this.inSpectionTypeId,
    this.inSpectionDate,
    this.inSpectionStartTime,
    this.inSpectionEndTime,
    this.auctionDate,
    this.auctionTime,
    this.petsAllowed,
    this.bondDeposit,
    this.rentalCostFrom,
    this.rentalCostTo,
    this.bed,
    this.bath,
    this.garage,
    this.pool,
    this.landSize,
    this.landUnitsofMeasure,
    this.buildingSize,
    this.buildingUnitsofMeasure,
    this.saleType,
    this.costType,
    this.inSpectionType,
    this.propertyTypeId,
    this.propertyTypeName,
    this.myRating,
    this.businessWebsite,
    this.realEstateLogo,
    this.spam,
    this.isPremiumUserListing,
  });

  BusinessProfileModel.fromJson(Map<String, dynamic> json) {
    contactPhone = json['contactPhone'];
    contactEmail = json['contactEmail'];
    contactName = json['contactName'];
    productSellURL = json['sellURL'];
    classifiedLogo = json['classifiedLogo'];
    communityId = json['communityId'];
    communityName = json['communityName'];
    itemName = json['itemName'];
    autoTypeName = json['autoTypeName'];
    itemDescription = json['itemDescription'];
    price = json['price'];
    currency = json['currency'];
    classifiedType = json['classifiedType'];
    classifiedId = json['classifiedId'];
    businessProfileId = json['businessProfileId'];
    businessTypeId = json['businessTypeId'];
    industryTypeId = json['industryTypeId'];
    industryTypeName = json['industryTypeName'];
    businessTypeTitle = json['businessTypeTitle'];
    userName = json['userName'];
    jobId = json['jobId'];
    communityId = json['communityId'];
    communityName = json['communityName'];
    jobTitle = json['jobTitle'];
    userUUID = json['userUUID'];
    businessName = json['businessName'];
    description = json['description'];
    registrationNumber = json['registrationNumber'];
    businessTypeCode = json['businessTypeCode'];
    city = json['city'];
    state = json['state'];
    countryCode = json['countryCode'];
    countryPhoneCode = json['countryPhoneCode'];
    country = json['country'];
    address = json['address'];
    email = json['email'];
    webSite = json['webSite'];
    phone = json['phone'];
    visibilityType = json['visibilityType'];
    docFile = json['docFile'];
    priceFrom = json['priceFrom'];
    priceTo = json['priceTo'];
    endDate = json['endDate'];
    endTime = json['endTime'];
    currency = json['currency'];
    duration = json['duration'];
    jobLogo = json['jobLogo'];
    isShowStreetAddress = json['isShowStreetAddress'];
    businessLogo = json['businessLogo'];
    recordStatus = json['recordStatus'];
    if (json['images'] != null) {
      images = <BusinessImagesModel>[];
      json['images'].forEach((v) {
        images!.add(BusinessImagesModel.fromJson(v));
      });
    }
    if (json['jobRequirements'] != null) {
      jobRequirements = <JobRequirements>[];
      json['jobRequirements'].forEach((v) {
        jobRequirements!.add(JobRequirements.fromJson(v));
      });
    }
    isTrustedUser = json['isTrustedUser'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    accountType = json['accountType'];
    dateCreated = json['dateCreated'];
    boostDate = json['boostDate'];
    dateModified = json['dateModified'];
    contactName = json['contactName'];
    contactEmail = json['contactEmail'];
    contactPhone = json['contactPhone'];
    uuid = json['uuid'];
    promoId = json['promoId'];
    promoCategoryId = json['promoCategoryId'];
    promoCategoryName = json['promoCategoryName'];
    promoName = json['promoName'];
    promoStartDate = json['promoStartDate'];
    promoEndDate = json['promoEndDate'];
    promoURL = json['promoURL'];
    promoLogo = json['promoLogo'];
    selfBookmark = json['selfBookmark'];
    selfLike = json['selfLike'];
    totalLikeCount = json['totalLikeCount'];
    workerId = json['workerId'];
    skillId = json['skillId'];
    workerName = json['workerName'];
    skillName = json['skillName'];
    distanceKm = json['distanceKm'];
    radiusId = json['radiusId'];
    radiusName = json['radiusName'];
    cvFile = json['cvFile'];
    workerLogo = json['workerLogo'];
    if (json['skills'] != null) {
      skills = <WorkerSkillsResult>[];
      json['skills'].forEach((v) {
        skills!.add(WorkerSkillsResult.fromJson(v));
      });
    }
    myRating = json['myRating'] != null
        ? MyRating.fromJson(json['myRating'])
        : null;

    selfBookMark = json['selfBookMark'];
    totalLikeCount = json['totalLikeCount'];
    selfBookMark = json['selfBookMark'];
    selfLike = json['selfLike'];
    communityTypeId = json['communityTypeId'];
    title = json['title'];
    communityListingTypeId = json['communityListingTypeId'];
    communityListingType = json['communityListingType'];
    otherListingType = json['otherListingType'];
    otherSkill = json['otherSkill'];
    phoneDialCode = json['phoneDialCode'];
    phoneCountryCode = json['phoneCountryCode'];
    communityLogo = json['communityLogo'];
    autoId = json['autoId'];
    autoType = json['autoType'];
    autoTitle = json['autoTitle'];
    autoRegistered = json['autoRegistered'];
    autoRegistrationNumber = json['autoRegistrationNumber'];
    autoDescription = json['autoDescription'];
    autoYear = json['autoYear'];
    autoSaleType = json['autoSaleType'];
    vehicleCondition = json['vehicleCondition'];
    paymentInterval = json['paymentInterval'];
    avgRating = json['avgRating'];
    autoLogo = json['autoLogo'];
    selfReview = json['selfReview'];
    totalReviewCount = json['totalReviewCount'];
    realEstateId = json['realEstateId'];
    saleTypeId = json['saleTypeId'];
    costTypeId = json['costTypeId'];
    inSpectionTypeId = json['inSpectionTypeId'];
    inSpectionDate = json['inSpectionDate'];
    inSpectionStartTime = json['inSpectionStartTime'];
    inSpectionEndTime = json['inSpectionEndTime'];
    auctionDate = json['auctionDate'];
    auctionTime = json['auctionTime'];
    petsAllowed = json['petsAllowed'];
    bondDeposit = json['bondDeposit'];
    rentalCostFrom = json['rentalCostFrom'];
    rentalCostTo = json['rentalCostTo'];
    bed = json['bed'];
    bath = json['bath'];
    garage = json['garage'];
    pool = json['pool'];
    landSize = json['landSize'];
    landUnitsofMeasure = json['landUnitsofMeasure'];
    buildingSize = json['buildingSize'];
    buildingUnitsofMeasure = json['buildingUnitsofMeasure'];
    saleType = json['saleType'];
    costType = json['costType'];
    inSpectionType = json['inSpectionType'];
    propertyTypeId = json['propertyTypeId'];
    propertyTypeName = json['propertyTypeName'];
    totalReviewCount = json['totalReviewCount'];
    selfReview = json['selfReview'];
    businessWebsite = json['businessWebsite'];
    realEstateLogo = json['realEstateLogo'];
    spam = json['spam'];
    isPremiumUserListing = json['isPremiumUserListing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contactPhone'] = contactPhone;
    data['contactEmail'] = contactEmail;
    data['contactName'] = contactName;
    data['productSellURL'] = productSellURL;
    data['classifiedLogo'] = classifiedLogo;
    data['communityId'] = communityId;
    data['communityName'] = communityName;
    data['itemName'] = itemName;
    data['classifiedId'] = classifiedId;
    data['itemDescription'] = itemDescription;
    data['classifiedType'] = classifiedType;
    data['businessProfileId'] = businessProfileId;
    data['businessTypeId'] = businessTypeId;
    data['industryTypeId'] = industryTypeId;
    data['industryTypeName'] = industryTypeName;
    data['businessTypeTitle'] = businessTypeTitle;
    data['userName'] = userName;
    data['userUUID'] = userUUID;
    data['businessName'] = businessName;
    data['description'] = description;
    data['jobId'] = jobId;
    data['communityId'] = communityId;
    data['jobTitle'] = jobTitle;
    data['registrationNumber'] = registrationNumber;
    data['businessTypeCode'] = businessTypeCode;
    data['city'] = city;
    data['state'] = state;
    data['countryCode'] = countryCode;
    data['countryPhoneCode'] = countryPhoneCode;
    data['country'] = country;
    data['address'] = address;
    data['docFile'] = docFile;
    data['priceFrom'] = priceFrom;
    data['priceTo'] = priceTo;
    data['endDate'] = endDate;
    data['endTime'] = endTime;
    data['currency'] = currency;
    data['duration'] = duration;
    data['jobLogo'] = jobLogo;
    data['email'] = email;
    data['webSite'] = webSite;
    data['phone'] = phone;
    data['visibilityType'] = visibilityType;
    data['isShowStreetAddress'] = isShowStreetAddress;
    data['businessLogo'] = businessLogo;
    data['recordStatus'] = recordStatus;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (jobRequirements != null) {
      data['jobRequirements'] = jobRequirements!.map((v) => v.toJson()).toList();
    }
    data['isTrustedUser'] = isTrustedUser;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['location'] = location;
    data['accountType'] = accountType;
    data['contactName'] = contactName;
    data['contactEmail'] = contactEmail;
    data['contactPhone'] = contactPhone;
    data['totalLikeCount'] = totalLikeCount;
    data['selfBookMark'] = selfBookMark;
    data['selfLike'] = selfLike;
    data['dateCreated'] = dateCreated;
    data['boostDate'] = boostDate;
    data['dateModified'] = dateModified;
    data['uuid'] = uuid;
    data['promoId'] = promoId;
    data['promoCategoryId'] = promoCategoryId;
    data['promoCategoryName'] = promoCategoryName;
    data['promoName'] = promoName;
    data['promoStartDate'] = promoStartDate;
    data['promoEndDate'] = promoEndDate;
    data['promoURL'] = promoURL;
    data['promoLogo'] = promoLogo;
    data['selfBookmark'] = selfBookmark;
    data['selfLike'] = selfLike;
    data['totalLikeCount'] = totalLikeCount;
    data['workerId'] = workerId;
    data['radiusId'] = radiusId;
    data['radiusName'] = radiusName;
    data['cvFile'] = cvFile;
    data['workerLogo'] = workerLogo;
    data['communityTypeId'] = communityTypeId;
    data['title'] = title;
    data['communityListingTypeId'] = communityListingTypeId;
    data['communityListingType'] = communityListingType;
    data['otherListingType'] = otherListingType;
    data['otherSkill'] = otherSkill;
    data['phoneDialCode'] = phoneDialCode;
    data['phoneCountryCode'] = phoneCountryCode;
    data['communityLogo'] = communityLogo;
    data['autoId'] = autoId;
    data['autoType'] = autoType;
    data['autoTypeName'] = autoTypeName;
    data['autoTitle'] = autoTitle;
    data['autoRegistered'] = autoRegistered;
    data['autoRegistrationNumber'] = autoRegistrationNumber;
    data['autoDescription'] = autoDescription;
    data['autoYear'] = autoYear;
    data['autoSaleType'] = autoSaleType;
    data['vehicleCondition'] = vehicleCondition;
    data['paymentInterval'] = paymentInterval;
    data['avgRating'] = avgRating;
    data['autoLogo'] = autoLogo;
    data['selfReview'] = selfReview;
    data['totalReviewCount'] = totalReviewCount;
    data['realEstateId'] = realEstateId;
    data['saleTypeId'] = saleTypeId;
    data['costTypeId'] = costTypeId;
    data['inSpectionTypeId'] = inSpectionTypeId;
    data['inSpectionDate'] = inSpectionDate;
    data['inSpectionStartTime'] = inSpectionStartTime;
    data['inSpectionEndTime'] = inSpectionEndTime;
    data['auctionDate'] = auctionDate;
    data['auctionTime'] = auctionTime;
    data['petsAllowed'] = petsAllowed;
    data['bondDeposit'] = bondDeposit;
    data['rentalCostFrom'] = rentalCostFrom;
    data['rentalCostTo'] = rentalCostTo;
    data['bed'] = bed;
    data['bath'] = bath;
    data['garage'] = garage;
    data['pool'] = pool;
    data['landSize'] = landSize;
    data['landUnitsofMeasure'] = landUnitsofMeasure;
    data['buildingSize'] = buildingSize;
    data['buildingUnitsofMeasure'] = buildingUnitsofMeasure;
    data['saleType'] = saleType;
    data['costType'] = costType;
    data['inSpectionType'] = inSpectionType;
    data['propertyTypeId'] = propertyTypeId;
    data['propertyTypeName'] = propertyTypeName;
    data['totalReviewCount'] = totalReviewCount;
    data['selfReview'] = selfReview;
    data['spam'] = spam;
    if (myRating != null) {
      data['myRating'] = myRating!.toJson();
    }
    data['businessWebsite'] = businessWebsite;
    data['realEstateLogo'] = realEstateLogo;
    data['isPremiumUserListing'] = isPremiumUserListing;
    return data;
  }


  ListingCommonModel getListingIdOrLogo({required String? categoryName}) {
    switch (categoryName) {
      case AddListingFormConstants.business:
        return ListingCommonModel(
          itemId: businessProfileId,
          itemLogo: businessLogo,
          itemDescription: description,
            itemName: businessName,

        );
     case AddListingFormConstants.promo:
       return ListingCommonModel(
         itemId: promoId,
         itemLogo: promoLogo,
           itemDescription:description,
           itemName: promoName

       );

     case AddListingFormConstants.worker:
       return ListingCommonModel(
           itemId: workerId,
           itemLogo: workerLogo,
           itemDescription: description,
           itemName: workerName,


       );
    case AddListingFormConstants.classified:
      return ListingCommonModel(
          itemId: classifiedId,
          itemLogo: communityLogo,
          itemDescription: itemDescription,
          itemName: itemName

      );
    case AddListingFormConstants.community:
      return ListingCommonModel(
          itemId: communityId,
          itemLogo: communityLogo,
        itemDescription: description,
        itemName: title,
      );
    case AddListingFormConstants.auto:
      return ListingCommonModel(
          itemId: autoId,
          itemLogo: autoLogo,
          itemDescription: autoDescription,
          itemName: autoTypeName

      );
    case AddListingFormConstants.realEstate:
      return ListingCommonModel(
          itemId: realEstateId,
          itemLogo: realEstateLogo,
          itemDescription: description,
          itemName: title
      );
      case AddListingFormConstants.job:
      return ListingCommonModel(
          itemId: jobId,
          itemLogo: jobLogo,
          itemDescription: description,
        itemName: jobTitle,
      );
      default:
        return ListingCommonModel();
    }
  }


}
class MyRating {
  int? ratingId;
  int? ratingThumbsUp;
  String? ratingComment;
  String? dateCreated;
  String? dateModified;
  String? uuid;

  MyRating(
      {this.ratingId,
        this.ratingThumbsUp,
        this.ratingComment,
        this.dateCreated,
        this.dateModified,
        this.uuid});

  MyRating.fromJson(Map<String, dynamic> json) {
    ratingId = json['ratingId'];
    ratingThumbsUp = json['ratingThumbsUp'];
    ratingComment = json['ratingComment'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ratingId'] = ratingId;
    data['ratingThumbsUp'] = ratingThumbsUp;
    data['ratingComment'] = ratingComment;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['uuid'] = uuid;
    return data;
  }
}

class BusinessImagesModel {
  int? id;
  String? fileName;
  String? fileLocalPath;
  int? fileType;
  int? displayOrder;
  int? displayOrderOldIndex;
  bool? isDeleted;

  BusinessImagesModel({this.id,
    this.fileName,
    this.fileType,
    this.displayOrder,
    this.fileLocalPath,
    this.displayOrderOldIndex,
    this.isDeleted,
  });

  BusinessImagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['fileName'];
    fileType = json['fileType'];
    displayOrder = json['displayOrder'];
    fileLocalPath = json['fileLocalPath'];
    displayOrderOldIndex = json['displayOrderOldIndex'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null) data['id'] = id;
    if(fileName!=null) data['fileName'] = fileName;
    if(fileType!=null) data['fileType'] = fileType;
    if(displayOrder!=null) data['displayOrder'] = displayOrder;
    if(fileLocalPath!=null) data['fileLocalPath'] = fileLocalPath;
    if(displayOrderOldIndex!=null) data['displayOrderOldIndex'] = displayOrderOldIndex;
    if(isDeleted!=null) data['isDeleted'] = isDeleted;
    return data;
  }
}

class JobRequirements {
  int? jobRequirementId;
  String? jobRequirement;
  int? displayOrder;
  bool? isDeleted; // additional field to mark as deleted

  JobRequirements({
    this.jobRequirementId,
    this.jobRequirement,
    this.displayOrder,
    this.isDeleted = false, // Default value is false (not deleted)
  });

  JobRequirements.fromJson(Map<String, dynamic> json) {
    jobRequirementId = json['jobRequirementId'];
    jobRequirement = json['jobRequirement'];
    displayOrder = json['displayOrder'];
    isDeleted = json['isDeleted'] ?? false; // Handle the case where 'isDeleted' may be missing
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jobRequirementId'] = jobRequirementId;
    data['jobRequirement'] = jobRequirement;
    data['displayOrder'] = displayOrder;
    data['isDeleted'] = isDeleted; // Include 'isDeleted' in the JSON data
    return data;
  }
}


class ListingCommonModel {
  String? itemName;
  String? itemDescription;
  int? itemId;
  String? itemLogo;


  ListingCommonModel({
    this.itemName,
    this.itemDescription,
   this.itemId,
    this.itemLogo
  });

  ListingCommonModel.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    itemDescription = json['itemDescription'];
    itemId = json['itemId'];
    itemLogo = json['itemLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['itemName'] = itemName;

    data['itemDescription'] = itemDescription;
    return data;
  }


}
