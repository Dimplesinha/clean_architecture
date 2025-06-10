import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';

class AdvanceSearchModel {
  int? statusCode;
  String? message;
  List<SearchResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  AdvanceSearchModel({statusCode, message, result, isSuccess, utcTimeStamp});

  AdvanceSearchModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <SearchResult>[];
      json['result'].forEach((v) {
        result!.add(SearchResult.fromJson(v));
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

class SearchResult {
  int? count;
  List<AdvanceSearchItem>? items;

  SearchResult({count, items});

  SearchResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <AdvanceSearchItem>[];
      json['items'].forEach((v) {
        items!.add(AdvanceSearchItem.fromJson(v));
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

class AdvanceSearchItem {
  int? searchId;
  int? categoryId;
  String? categoryName;
  String? keyword;
  String? advanceSearch;
  double? latitude;
  double? longitude;
  String? location;
  String? countryName;
  String? sortBy;
  String? iconUrl;
  String? sortOrder;
  int? visibilityType;
  String? saveSearch;
  String? dateCreated;
  String? dateModified;
  String? uuid;
  bool? isChecked = false;

  AdvanceSearchItem(
      {searchId,
      categoryId,
      categoryName,
      keyword,
      advanceSearch,
      latitude,
      longitude,
      location,
      countryName,
      sortBy,
      sortOrder,
        iconUrl,
      visibilityType,
      saveSearch,
      dateCreated,
      dateModified,
      uuid});

  AdvanceSearchItem.fromJson(Map<String, dynamic> json) {
    searchId = json['searchId'];
    iconUrl = json['iconUrl'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    keyword = json['keyword'];
    advanceSearch = json['advanceSearch'];
    // Handle potential null values and type mismatches
    latitude = double.tryParse(json['latitude']!.toString()) ?? 0.0;
    longitude = double.tryParse(json['longitude']!.toString()) ?? 0.0;
    location = json['location'];
    countryName = json['country'];
    sortBy = json['sortBy'];
    sortOrder = json['sortOrder'];
    visibilityType = json['visibilityType'];
    saveSearch = json['saveSearch'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['searchId'] = searchId;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['keyword'] = keyword;
    data['advanceSearch'] = advanceSearch;
    data['iconUrl'] = iconUrl;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['location'] = location;
    data['country'] = countryName;
    data['sortBy'] = sortBy;
    data['sortOrder'] = sortOrder;
    data['visibilityType'] = visibilityType;
    data['saveSearch'] = saveSearch;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['uuid'] = uuid;
    return data;
  }

  String get getItemSortBy {
    if (sortOrder != null || sortOrder?.isNotEmpty == true) {
      return AppConstants.priceOrderToOptions[sortOrder] ?? '';
    } else if (visibilityType != null) {
      return DropDownConstants.visibilityDropDownListWithNearMe[visibilityType] ?? '';
    }
    return AppConstants.n_a;
  }
}
