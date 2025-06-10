import 'package:workapp/src/core/constants/app_constants.dart';

class AddListingCategory {
  int? statusCode;
  String? message;
  List<AddListingCategoryList>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  AddListingCategory(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  AddListingCategory.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <AddListingCategoryList>[];
      json['result'].forEach((v) {
        result!.add(AddListingCategoryList.fromJson(v));
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

class AddListingCategoryList {
  int? formId;
  String? formName;
  String? accountType;
  String? iconUrl;
  int? categoryId;
  String? dateCreated;
  String? dateModified;
  String? uuid;

  AddListingCategoryList(
      {this.formId,
        this.formName,
        this.accountType,
        this.categoryId,
        this.iconUrl,
        this.dateCreated,
        this.dateModified,
        this.uuid});

  AddListingCategoryList.fromJson(Map<String, dynamic> json) {
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
  String getCategoryIcon() {
    return AppConstants.categoryNameIconMap[formName] ?? AppConstants.categoryNameIconMap['Business'] ?? 'assets/icons/category/business_category.svg';
  }
}
