class RatingModel {
  int? statusCode;
  String? message;
  dynamic result;
  bool? isSuccess;
  String? utcTimeStamp;

  RatingModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  RatingModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];

    // Check the type of result
    if (json['result'] is List) {
      result = <RatingResult>[];
      json['result'].forEach((v) {
        result.add(RatingResult.fromJson(v));
      });
    } else if (json['result'] is int) {
      result = json['result']; // Assign directly if it's an int
    }

    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;

    // Check the type of result for serialization
    if (result is List<RatingResult>) {
      data['result'] = (result as List<RatingResult>).map((v) => v.toJson()).toList();
    } else if (result is int) {
      data['result'] = result;
    }

    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}


class RatingResult {
  int? count;
  List<RatingItems>? items;

  RatingResult({this.count, this.items});

  RatingResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <RatingItems>[];
      json['items'].forEach((v) {
        items!.add(RatingItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingItems {
  int? ratingId;
  String? listingName;
  int? categoryId;
  String? categoryName;
  int? listingId;
  int? ratingThumbsUp;
  String? ratingComment;
  String? listingLogo;
  int? userId;
  String? userName;
  String? profilePic;
  String? dateCreated;
  String? dateModified;
  String? uuid;

  RatingItems(
      {this.ratingId,
        this.listingName,
        this.categoryId,
        this.categoryName,
        this.listingId,
        this.ratingThumbsUp,
        this.ratingComment,
        this.listingLogo,
        this.dateCreated,
        this.dateModified,
        this.userId,
        this.userName,
        this.profilePic,
        this.uuid});

  RatingItems.fromJson(Map<String, dynamic> json) {
    ratingId = json['ratingId'];
    listingName = json['listingName'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    listingId = json['listingId'];
    ratingThumbsUp = json['ratingThumbsUp'];
    ratingComment = json['ratingComment'];
    listingLogo = json['listingLogo'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    userId = json['userId'];
    userName = json['userName'];
    profilePic = json['profilePic'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ratingId'] = ratingId;
    data['listingName'] = listingName;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['listingId'] = listingId;
    data['ratingThumbsUp'] = ratingThumbsUp;
    data['ratingComment'] = ratingComment;
    data['listingLogo'] = listingLogo;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['userId'] = userId;
    data['userName'] = userName;
    data['profilePic'] = profilePic;
    data['uuid'] = uuid;
    return data;
  }
}