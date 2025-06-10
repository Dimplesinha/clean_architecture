import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/date_time_utils.dart';

class StatisticsInsightModel {
  int? statusCode;
  String? message;
  StatisticsInsightResult? result;
  bool? isSuccess;
  String? utcTimeStamp;

  StatisticsInsightModel({
    this.statusCode,
    this.message,
    this.result,
    this.isSuccess,
    this.utcTimeStamp,
  });

  StatisticsInsightModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? StatisticsInsightResult.fromJson(json['result']) : null;
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

class StatisticsInsightResult {
  int? listingId;
  String? listingName;
  String? websiteCount;
  String? dateCreated;
  String? boostDate;
  String? totalActiveTime;
  String? viewPerMonth;
  String? totalLikeCount;
  String? totalBookMark;
  String? totalTimeShared;
  String? uniqueVisitor;
  String? viewCount;
  String? calls;
  String? email;
  String? message;

  StatisticsInsightResult({
    this.listingId,
    this.listingName,
    this.websiteCount,
    this.dateCreated,
    this.boostDate,
    this.totalActiveTime,
    this.viewPerMonth,
    this.totalLikeCount,
    this.totalBookMark,
    this.totalTimeShared,
    this.uniqueVisitor,
    this.viewCount,
    this.calls,
    this.email,
    this.message,
  });

  StatisticsInsightResult.fromJson(Map<String, dynamic> json) {
    listingId = json['listingId'];
    listingName = json['listingName'];
    websiteCount = json['websiteCount'];
    dateCreated = json['dateCreated'];
    boostDate = json['boostDate'];
    totalActiveTime = json['totalActiveTime'];
    viewPerMonth = json['viewPerMonth'];
    totalLikeCount = json['totalLikeCount'];
    totalBookMark = json['totalBookMark'];
    totalTimeShared = json['totalTimeShared'];
    uniqueVisitor = json['uniqueVisitor'];
    viewCount = json['viewCount'];
    calls = json['calls'];
    email = json['email'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listingId'] = listingId;
    data['listingName'] = listingName;
    data['websiteCount'] = websiteCount;
    data['dateCreated'] = dateCreated;
    data['boostDate'] = boostDate;
    data['totalActiveTime'] = totalActiveTime;
    data['viewPerMonth'] = viewPerMonth;
    data['totalLikeCount'] = totalLikeCount;
    data['totalBookMark'] = totalBookMark;
    data['totalTimeShared'] = totalTimeShared;
    data['uniqueVisitor'] = uniqueVisitor;
    data['viewCount'] = viewCount;
    data['calls'] = calls;
    data['email'] = email;
    data['message'] = message;
    return data;
  }

  String get avgViewsPerMonth {
    if (viewPerMonth != null) {
      return AppUtils.formatInsightsNumbers(num.parse(viewPerMonth!));
    }
    return '0';
  }

  String get getDateCreated {
    if (dateCreated != null) {
      DateTime time = DateTimeUtils.instance.stringToDateInLocal(string: dateCreated!);
      return DateTimeUtils.instance.timeStampToDate(time);
    }
    return '-';
  }

  String get getTotalActiveTime {
    if (dateCreated != null) {
      var convertedDate = DateTime.parse(dateCreated!);
      DateTime utcDateTime = DateTime.utc(
          convertedDate.year,
          convertedDate.month,
          convertedDate.day,
          convertedDate.hour,
          convertedDate.minute,
          convertedDate.second,
          convertedDate.millisecond); // Example UTC DateTime
      return DateTimeUtils.instance.timeDifference(value: utcDateTime);
    }
    return '-';
  }

  String get getLastRefreshDateTime {
    if (boostDate != null) {
      DateTime time = DateTimeUtils.instance.stringToDateInLocal(string: boostDate!);
      return DateTimeUtils.instance.timeStampToDateTime(time);
    }
    return '-';
  }
}
