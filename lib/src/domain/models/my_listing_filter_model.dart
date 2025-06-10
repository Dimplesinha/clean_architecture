class ListingResponse {
  int? code;
  String? success;
  String? message;
  List<ListingData>? data;

  ListingResponse({this.code, this.success, this.message, this.data});

  ListingResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ListingData>[];
      json['data'].forEach((v) {
        data?.add(ListingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListingData {
  int? listingId;
  String? listingTitle;
  String? location;
  String? time;
  String? image;
  String? price;
  bool? isBoosted;
  bool? isAdActive;
  String? type;

  ListingData({
    this.listingId,
    this.listingTitle,
    this.location,
    this.time,
    this.image,
    this.isBoosted,
    this.isAdActive,
    this.price,
    this.type,
  });

  ListingData.fromJson(Map<String, dynamic> json) {
    listingId = json['listingId'];
    listingTitle = json['listingTitle'];
    location = json['location'];
    price = json['price'];
    time = json['time'];
    image = json['image'];
    isBoosted = json['isBoosted'];
    isAdActive = json['isAdActive'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['listingId'] = listingId;
    data['listingTitle'] = listingTitle;
    data['location'] = location;
    data['price'] = price;
    data['time'] = time;
    data['image'] = image;
    data['isBoosted'] = isBoosted;
    data['isAdActive'] = isAdActive;
    data['type'] = type;
    return data;
  }

  @override
  String toString() {
    return 'ListingData{listingId: $listingId, listingTitle: $listingTitle, location: $location, time: $time, image: $image, price: $price, isBoosted: $isBoosted,isAdActive: $isAdActive, type: $type}';
  }
}
