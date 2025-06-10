class ReviewListResponse {
  int? statusCode;
  String? message;
  ReviewListModel? result;
  bool? isSuccess;
  String? utcTimeStamp;

  ReviewListResponse(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  ReviewListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? ReviewListModel.fromJson(json['result']) : null;
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

class ReviewListModel {
  int? totalReviewCount;
  List<Reviews>? review;

  ReviewListModel({this.totalReviewCount, this.review});

  ReviewListModel.fromJson(Map<String, dynamic> json) {
    totalReviewCount = json['totalReviewCount'];
    if (json['review'] != null) {
      review = <Reviews>[];
      json['review'].forEach((v) {
        review!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalReviewCount'] = totalReviewCount;
    if (review != null) {
      data['review'] = review!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  int? ratingId;
  int? userId;
  String? userName;
  String? profilePic;
  int? ratingThumbsUp;
  String? ratingComment;
  String? dateCreated;

  Reviews(
      {this.ratingId,
        this.userId,
        this.userName,
        this.profilePic,
        this.ratingThumbsUp,
        this.ratingComment,
        this.dateCreated});

  Reviews.fromJson(Map<String, dynamic> json) {
    ratingId = json['ratingId'];
    userId = json['userId'];
    userName = json['userName'];
    profilePic = json['profilePic'];
    ratingThumbsUp = json['ratingThumbsUp'];
    ratingComment = json['ratingComment'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ratingId'] = ratingId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['profilePic'] = profilePic;
    data['ratingThumbsUp'] = ratingThumbsUp;
    data['ratingComment'] = ratingComment;
    data['dateCreated'] = dateCreated;
    return data;
  }
}