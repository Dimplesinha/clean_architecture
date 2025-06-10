import 'dart:convert';

class DynamicListingDetailModel {
  final int statusCode;
  final String message;
  final Result result;
  final bool isSuccess;
  final String utcTimeStamp;
  

  DynamicListingDetailModel({
    required this.statusCode,
    required this.message,
    required this.result,
    required this.isSuccess,
    required this.utcTimeStamp,
  });

  factory DynamicListingDetailModel.fromJson(Map<String, dynamic> json) {
    return DynamicListingDetailModel(
      statusCode: json["statusCode"],
      message: json["message"],
      result: Result.fromJson(jsonDecode(json["result"])),
      isSuccess: json["isSuccess"],
      utcTimeStamp: json["utcTimeStamp"]
    );
  }

  get userUUID => null;
}

class Result {
  final List<DynamicJsonItem> dynamicJson;
  String? dateCreated;
  String? dateModified;
  String? userUUID;
  int? totalLikeCount;
  bool? selfLike;
  bool? selfBookMark;
  int? totalReviewCount;
  bool? selfReview;
  String? avgRating;
  List<MyRatingItem>? myRating;
  bool? spam;
  final dynamic spamDate;
  String? boostDate;
  bool? isPremiumUserListing;
  int? id;
  String? category;
  int? categoryId;
  String? businessLogo;
  List<ImageItem>? images;
  int? accountType;
  String? userId;
  String? userName;
  String? recordStatus;
  int? recordStatusID;

  Result({
    required this.dynamicJson,
    required this.dateCreated,
    required this.dateModified,
    required this.userUUID,
    required this.totalLikeCount,
    required this.selfLike,
    required this.selfBookMark,
    required this.totalReviewCount,
    required this.selfReview,
    required this.avgRating,
    required this.myRating,
    required this.spam,
    required this.spamDate,
    required this.boostDate,
    required this.isPremiumUserListing,
    required this.id,
    required this.category,
    required this.categoryId,
    required this.businessLogo,
    required this.images,
    required this.accountType,
    required this.userId,
    required this.userName,
    required this.recordStatus,
    required this.recordStatusID,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      dynamicJson: List<DynamicJsonItem>.from(json["DynamicJson"].map((x) => DynamicJsonItem.fromJson(x))),
      dateCreated: json["dateCreated"],
      dateModified: json["dateModified"],
      userUUID: json["userUUID"],
      totalLikeCount: json["totalLikeCount"],
      selfLike: json["selfLike"],
      selfBookMark: json["selfBookMark"],
      totalReviewCount: json["totalReviewCount"],
      selfReview: json["selfReview"],
      avgRating: json["avgRating"],
      myRating: (json["myRating"] as List?)?.map((x) => MyRatingItem.fromJson(x)).toList() ?? [],
      spam: json["spam"],
      spamDate: json["spamDate"],
      boostDate: json["boostDate"],
      isPremiumUserListing: json["isPremiumUserListing"],
      id: json["id"],
      category: json["category"],
      categoryId: json["categoryId"],
      businessLogo: json["businessLogo"],
      images: (json["images"] as List?)?.map((x) => ImageItem.fromJson(x)).toList() ?? [],
      //List<ImageItem>.from(json["images"]?.map((x) => ImageItem.fromJson(x))),
      accountType: json["accountType"],
      userId: json["userId"],
      userName: json["userName"],
      recordStatus: json["recordStatus"],
      recordStatusID: json["recordStatusID"],
    );
  }
}

class DynamicJsonItem {
  String? key;
  String? displayLabel;
  String? value;
  int? view;
  int? orderValue;
  String? fieldName;
  String? fieldType;
  int? dropdownBindType;
  int? inheritId;
  String? icon;

  DynamicJsonItem({
    required this.key,
    required this.displayLabel,
    required this.value,
    required this.view,
    required this.orderValue,
    required this.fieldName,
    required this.fieldType,
    required this.dropdownBindType,
    required this.inheritId,
    required this.icon,
  });

  factory DynamicJsonItem.fromJson(Map<String, dynamic> json) {
    return DynamicJsonItem(
      key: json["key"],
      displayLabel: json["displayLabel"],
      value: json["value"],
      view: json["view"],
      orderValue: json["orderValue"],
      fieldName: json["fieldName"],
      fieldType: json["fieldType"],
      dropdownBindType: json["dropdownBindType"],
      inheritId: json["inheritId"],
      icon: json["icon"],
    );
  }

  get isNotEmpty => null;

  isNullOrEmpty() {}
}

class ImageItem {
  final int? id;
  final String fileName;
  final int fileType;
  final int displayOrder;

  ImageItem({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.displayOrder,
  });

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json["id"],
      fileName: json["fileName"],
      fileType: json["fileType"],
      displayOrder: json["displayOrder"],
    );
  }
}

class MyRatingItem {
  final int ratingId;
  final int ratingThumbsUp;
  final String ratingComment;
  final String dateCreated;
  final String dateModified;

  MyRatingItem({
    required this.ratingId,
    required this.ratingThumbsUp,
    required this.ratingComment,
    required this.dateCreated,
    required this.dateModified,
  });

  factory MyRatingItem.fromJson(Map<String, dynamic> json) {
    return MyRatingItem(
      ratingId: json["ratingId"],
      ratingThumbsUp: json["ratingThumbsUp"],
      ratingComment: json["ratingComment"],
      dateCreated: json["dateCreated"],
      dateModified: json["dateModified"],
    );
  }
}
