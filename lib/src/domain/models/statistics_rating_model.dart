import 'package:workapp/src/utils/date_time_utils.dart';

class StatisticsRatingsModel {
  int? statusCode;
  String? message;
  List<StatisticsRatingsResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  StatisticsRatingsModel({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  StatisticsRatingsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <StatisticsRatingsResult>[];
      json['result'].forEach((v) {
        result!.add(StatisticsRatingsResult.fromJson(v));
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

class StatisticsRatingsResult {
  int? count;
  List<StatisticsRatingsItems>? items;

  StatisticsRatingsResult({this.count, this.items});

  StatisticsRatingsResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <StatisticsRatingsItems>[];
      json['items'].forEach((v) {
        items!.add(StatisticsRatingsItems.fromJson(v));
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

class StatisticsRatingsItems {
  String? uuid;
  String? dateCreated;
  String? dateModified;
  String? userName;
  String? profilePic;
  String? ratingComment;
  int? ratingThumbsUp;

  StatisticsRatingsItems({
    this.uuid,
    this.dateCreated,
    this.dateModified,
    this.userName,
    this.profilePic,
    this.ratingComment,
    this.ratingThumbsUp,
  });

  StatisticsRatingsItems.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    userName = json['userName'];
    profilePic = json['profilePic'];
    ratingComment = json['ratingComment'];
    ratingThumbsUp = json['ratingThumbsUp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['userName'] = userName;
    data['profilePic'] = profilePic;
    data['ratingComment'] = ratingComment;
    data['ratingThumbsUp'] = ratingThumbsUp;
    return data;
  }

  String get getDateCreated {
    if (dateCreated != null) {
      DateTime time = DateTimeUtils.instance.stringToDateInLocal(string: dateCreated!);
      return DateTimeUtils.instance.timeStampToDate(time);
    }
    return '';
  }
}
