class RatingListModel {
  int? statusCode;
  String? message;
  RatingListResult? result;
  bool? isSuccess;
  String? utcTimeStamp;

  RatingListModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  RatingListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result =
    json['result'] != null ? RatingListResult.fromJson(json['result']) : null;
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

class RatingListResult {
  double? avgRating = 0.0;
  int? totalRatingCount;
  int? excellent;
  int? good;
  int? average;
  int? belowAverage;
  int? poor;

  RatingListResult(
      {this.avgRating,
        this.totalRatingCount,
        this.excellent,
        this.good,
        this.average,
        this.belowAverage,
        this.poor});

  RatingListResult.fromJson(Map<String, dynamic> json) {
    avgRating = json['avgRating'];
    totalRatingCount = json['totalRatingCount'];
    excellent = json['excellent'];
    good = json['good'];
    average = json['average'];
    belowAverage = json['belowAverage'];
    poor = json['poor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avgRating'] = avgRating;
    data['totalRatingCount'] = totalRatingCount;
    data['excellent'] = excellent;
    data['good'] = good;
    data['average'] = average;
    data['belowAverage'] = belowAverage;
    data['poor'] = poor;
    return data;
  }
}