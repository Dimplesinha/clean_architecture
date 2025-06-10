/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 16-09-2024
/// @Message : [ItemDetailsModel]

class ItemDetailsModel {
  int? code;
  String? success;
  String? message;
  ItemDetailData? data;

  ItemDetailsModel({this.code, this.success, this.message, this.data});

  ItemDetailsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ItemDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ItemDetailData {
  int? itemId;
  int? itemCategoryId;
  int? itemSubCategoryId;
  String? itemTitle;
  String? itemDescription;
  int? itemSellTypeId;
  String? itemSellTypeName;
  String? itemAvailability;
  double? itemLatitude;
  double? itemLongitude;
  double? itemDistance;
  String? itemAddress;
  double? itemPrice;
  String? itemCurrency;
  bool? itemIsSold;
  bool? itemIsFav;
  List<ItemImages>? itemImages;
  String? itemCreatedDate;

  ItemDetailData({
    this.itemId,
    this.itemCategoryId,
    this.itemSubCategoryId,
    this.itemTitle,
    this.itemAddress,
    this.itemDistance,
    this.itemDescription,
    this.itemSellTypeId,
    this.itemSellTypeName,
    this.itemAvailability,
    this.itemLatitude,
    this.itemLongitude,
    this.itemPrice,
    this.itemCurrency,
    this.itemIsSold,
    this.itemIsFav,
    this.itemImages,
    this.itemCreatedDate,
  });

  ItemDetailData.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    itemCategoryId = json['itemCategoryId'];
    itemSubCategoryId = json['itemSubCategoryId'];
    itemTitle = json['itemTitle'];
    itemDescription = json['itemDescription'];
    itemSellTypeId = json['itemSellTypeId'];
    itemSellTypeName = json['itemSellTypeName'];
    itemAvailability = json['itemAvailability'];
    itemLatitude = json['itemLatitude'];
    itemLongitude = json['itemLongitude'];
    if (json['itemDistance'] != null) {
      itemDistance = double.tryParse(json['itemDistance'].toString());
    }
    itemAddress = json['itemAddress'];
    itemPrice = json['itemPrice'];
    itemCurrency = json['itemCurrency'];
    itemIsSold = json['itemIsSold'];
    itemIsFav = json['itemIsFav'];
    if (json['itemImages'] != null) {
      itemImages = <ItemImages>[];
      json['itemImages'].forEach((v) {
        itemImages!.add(ItemImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemId'] = itemId;
    data['itemCategoryId'] = itemCategoryId;
    data['itemSubCategoryId'] = itemSubCategoryId;
    data['itemTitle'] = itemTitle;
    data['itemDescription'] = itemDescription;
    data['itemSellTypeId'] = itemSellTypeId;
    data['itemSellTypeName'] = itemSellTypeName;
    data['itemAvailability'] = itemAvailability;
    data['itemLatitude'] = itemLatitude;
    data['itemLongitude'] = itemLongitude;
    data['itemPrice'] = itemPrice;
    data['itemCurrency'] = itemCurrency;
    data['itemAddress'] = itemAddress;
    data['itemDistance'] = itemDistance;
    data['itemIsSold'] = itemIsSold;
    data['itemIsFav'] = itemIsFav;
    if (itemImages != null) {
      data['itemImages'] = itemImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemImages {
  int? itemImageId;
  String? itemImageURL;

  ItemImages({this.itemImageId, this.itemImageURL,});

  ItemImages.fromJson(Map<String, dynamic> json) {
    itemImageId = json['itemImageId'];
    itemImageURL = json['itemImageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemImageId'] = itemImageId;
    data['itemImageURL'] = itemImageURL;
    return data;
  }
}
