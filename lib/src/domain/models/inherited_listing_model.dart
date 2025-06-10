///
/// @AUTHOR : Mac OS
/// @DATE : 31/03/25
/// @Message :
///
class InheritedListingModel {
  int? statusCode;
  String? message;
  List<InheritList>? inheritList;
  bool? isSuccess;
  String? utcTimeStamp;

  InheritedListingModel(
      {this.statusCode,
        this.message,
        this.inheritList,
        this.isSuccess,
        this.utcTimeStamp});

  InheritedListingModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      inheritList = <InheritList>[];
      json['result'].forEach((v) {
        inheritList!.add(new InheritList.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (inheritList != null) {
      data['result'] = inheritList!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }
}

class InheritList {
  int? listingId;
  String? listingName;
  String? comparedValue;

  InheritList({this.listingId, this.listingName,this.comparedValue});

  InheritList.fromJson(Map<String, dynamic> json) {
    listingId = json['listingId'];
    listingName = json['listingName'];
    comparedValue = json['comparedValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listingId'] = listingId;
    data['listingName'] = listingName;
    data['comparedValue'] = comparedValue;
    return data;
  }
}
