import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/utils/date_time_utils.dart';

class CategoriesList {
  int? statusCode;
  String? message;
  List<CategoriesListResponse>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  CategoriesList(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  CategoriesList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CategoriesListResponse>[];
      json['result'].forEach((v) {
        result!.add(CategoriesListResponse.fromJson(v));
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

  String getCategoryLoadedDate() {
    DateTime tmp = DateTimeUtils.instance.stringToDateInLocal(string: utcTimeStamp.toString());

    return DateTimeUtils.instance.timeStampToDateOnly(tmp);
  }
}

class CategoriesListResponse {
  int? formId;
  String? formName;
  String? accountType;
  String? iconUrl;
  int? categoryId;
  String? dateCreated;
  String? dateModified;
  String? uuid;

  CategoriesListResponse(
      {this.formId,
        this.formName,
        this.accountType,
        this.categoryId,
        this.iconUrl,
        this.dateCreated,
        this.dateModified,
        this.uuid});

  CategoriesListResponse.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    formName = json['formName'];
    accountType = json['accountType'];
    iconUrl = json['iconUrl'];
    categoryId = json['categoryId'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['formId'] = formId;
    data['formName'] = formName;
    data['accountType'] = accountType;
    data['iconUrl'] = iconUrl;
    data['categoryId'] = categoryId;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['uuid'] = uuid;
    return data;
  }

  // Fetch icon path using the category name from the loaded map
  String getCategoryIcon() {
    return AppConstants.categoryNameIconMap[formName] ?? AppConstants.categoryNameIconMap['Business'] ?? '';
  }
}
