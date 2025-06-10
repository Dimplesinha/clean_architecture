import 'package:intl/intl.dart';
import 'package:workapp/src/core/core_exports.dart';

class MyListingResponse {
  int? statusCode;
  String? message;
  List<MyListingModel>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  MyListingResponse({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  MyListingResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <MyListingModel>[];
      json['result'].forEach((v) {
        result!.add(MyListingModel.fromJson(v));
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

class MyListingModel {
  int? count;
  List<MyListingItems>? items;

  MyListingModel({this.count, this.items});

  MyListingModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <MyListingItems>[];
      json['items'].forEach((v) {
        items!.add(MyListingItems.fromJson(v));
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

class MyListingItems {
  int? id;
  int? formId;
  String? listingName;
  String? planeName;
  String? logo;
  String? cityCountry;
  String? status;
  String? currency;
  String? priceFrom;
  String? priceTo;
  String? category;
  int? categoryId;
  String? type;
  String? boostDate;
  int? boostedBy;
  int? createdBy;
  String? createdByEmail;
  String? spamDate;
  int? spam;
  String? dateCreated;
  String? dateModified;
  bool? isBillBoard;
  int? listingLimit;
  String? subscriptionTitle;
  String? uuid;
  bool? isSelected;
  bool? isAvailableHistory;
  bool? selectAll;

  MyListingItems(
      {this.id,
      this.formId,
      this.listingName,
      this.planeName,
      this.logo,
      this.cityCountry,
      this.status,
      this.currency,
      this.priceFrom,
      this.priceTo,
      this.category,
      this.categoryId,
      this.type,
      this.boostDate,
      this.boostedBy,
      this.spamDate,
      this.createdBy,
      this.createdByEmail,
      this.spam,
      this.dateCreated,
      this.isBillBoard,
      this.dateModified,
      this.listingLimit,
      this.subscriptionTitle,
      this.isSelected,
      this.isAvailableHistory,
      this.selectAll,
      this.uuid});

  MyListingItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    listingName = json['listingName'];
    planeName = json['planeName'];
    logo = json['logo'];
    cityCountry = json['cityCountry'];
    status = json['status'];
    currency = json['currency'];
    priceFrom = json['priceFrom'];
    priceTo = json['priceTo'];
    category = json['category'];
    categoryId = json['categoryId'];
    type = json['type'];
    boostDate = json['boostDate'];
    boostedBy = json['boostedBy'];
    spamDate = json['spamDate'];
    spam = json['spam'];
    isBillBoard = json['isBillBoard'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    uuid = json['uuid'];
    createdBy = json['createdBy'];
    createdByEmail = json['createdByEmail'];
    isBillBoard = json['isBillBoard'];
    listingLimit = json['listingLimit'];
    subscriptionTitle = json['subscriptionTitle'];
    isSelected = json['isSelected'];
    selectAll = json['selectAll'];
    isAvailableHistory = json['isAvailableHistory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['formId'] = formId;
    data['listingName'] = listingName;
    data['planeName'] = planeName;
    data['logo'] = logo;
    data['cityCountry'] = cityCountry;
    data['status'] = status;
    data['currency'] = currency;
    data['priceFrom'] = priceFrom;
    data['priceTo'] = priceTo;
    data['category'] = category;
    data['categoryId'] = categoryId;
    data['type'] = type;
    data['boostDate'] = boostDate;
    data['boostedBy'] = boostedBy;
    data['spamDate'] = spamDate;
    data['spam'] = spam;
    data['isBillBoard'] = isBillBoard;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['uuid'] = uuid;
    data['createdBy'] = createdBy;
    data['createdByEmail'] = createdByEmail;
    data['isBillBoard'] = isBillBoard;
    data['listingLimit'] = listingLimit;
    data['subscriptionTitle'] = subscriptionTitle;
    data['isSelected'] = isSelected;
    data['selectAll'] = selectAll;
    data['isAvailableHistory'] = isAvailableHistory;
    return data;
  }

  bool get isExpired {
    if (dateModified == null) return false;
    final modifiedDate = DateFormat('yyyy-MM-dd').parse(dateModified!);
    final currentDate = DateTime.now();

    // Example: check if the listing is older than 30 days
    return currentDate.difference(modifiedDate).inDays > 30;
  }

  int statusId({required String? status}) {
    switch (status) {
      case AppConstants.activeStr:
        return 1;
      case AppConstants.inActiveStr:
        return 2;
      case AppConstants.deleteStatusStr:
        return 3;
      case AppConstants.draftStr:
        return 4;
      case AppConstants.underReviewStr:
        return 5;
      case AppConstants.rejectedStr:
        return 6;
      default:
        return 1;
    }
  }

  String get itemType {
    if (type?.contains(AppConstants.advertisement) ?? false) {
      return type.toString();
    }
    return '$type';
  }
}
