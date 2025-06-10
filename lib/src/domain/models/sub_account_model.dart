class SubAccountModel {
  int? statusCode;
  String? message;
  List<SubAccountModelResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  SubAccountModel(
      {this.statusCode,
        this.message,
        this.result,
        this.isSuccess,
        this.utcTimeStamp});

  SubAccountModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <SubAccountModelResult>[];
      json['result'].forEach((v) {
        result!.add(SubAccountModelResult.fromJson(v));
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

class SubAccountModelResult {
  int? count;
  List<SubAccountItems>? items;

  SubAccountModelResult({this.count, this.items});

  SubAccountModelResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <SubAccountItems>[];
      json['items'].forEach((v) {
        items!.add(SubAccountItems.fromJson(v));
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

class SubAccountItems {
  int? userId;
  String? userName;
  String? email;
  String? cityName;
  String? stateName;
  String? countryName;
  String? device;
  String? phoneNumber;
  int? profile;
  int? post;
  String? status;
  int? accountType;
  String? accountTypeValue;
  String? location;
  String? birthYear;
  String? profilePic;
  bool? otpVerified;
  String? dateCreated;
  String? dateModified;
  String? uuid;

  SubAccountItems(
      {this.userId,
        this.userName,
        this.email,
        this.cityName,
        this.stateName,
        this.countryName,
        this.device,
        this.phoneNumber,
        this.profile,
        this.post,
        this.status,
        this.accountType,
        this.accountTypeValue,
        this.location,
        this.birthYear,
        this.profilePic,
        this.otpVerified,
        this.dateCreated,
        this.dateModified,
        this.uuid});

  SubAccountItems.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    email = json['email'];
    cityName = json['city'];
    stateName = json['state'];
    countryName = json['country'];
    device = json['device'];
    phoneNumber = json['phoneNumber'];
    profile = json['profile'];
    post = json['post'];
    status = json['status'];
    accountType = json['accountType'];
    accountTypeValue = json['accountTypeValue'];
    location = json['location'];
    birthYear = json['birthYear'];
    profilePic = json['profilePic'];
    otpVerified = json['otpVerified'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['email'] = email;
    data['city'] = cityName;
    data['state'] = stateName;
    data['country'] = countryName;
    data['device'] = device;
    data['phoneNumber'] = phoneNumber;
    data['profile'] = profile;
    data['post'] = post;
    data['status'] = status;
    data['accountType'] = accountType;
    data['accountTypeValue'] = accountTypeValue;
    data['location'] = location;
    data['birthYear'] = birthYear;
    data['profilePic'] = profilePic;
    data['otpVerified'] = otpVerified;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['uuid'] = uuid;
    return data;
  }
}