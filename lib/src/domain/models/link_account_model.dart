/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12-12-2024
/// @Message : [LinkAccountModel]

class LinkAccountModel {
  int? statusCode;
  String? message;
  Result? result;
  bool? isSuccess;
  String? utcTimeStamp;

  LinkAccountModel({statusCode, message, result, isSuccess, utcTimeStamp});

  LinkAccountModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
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

class Result {
  String? uuid;
  String? dateCreated;
  String? dateModified;
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? biography;
  int? birthYear;
  String? gender;
  String? address;
  String? countryCode;
  String? country;
  String? state;
  String? city;
  int? latitude;
  int? longitude;
  String? profilepic;
  String? phoneNumber;
  int? profileVisibilityType;
  String? token;
  UserType? userType;
  String? roleUUID;
  bool? otpVerified;
  bool? isTemporaryPassword;
  bool? pushNotification;
  bool? emailNotification;
  String? resetPasswordToken;
  bool? isPasswordAvailable;
  String? phoneDialCode;
  String? phoneCountryCode;
  bool? isAutoVerified;
  String? googleUserId;
  String? linkdinUserId;
  String? appleUserId;
  String? accountType;

  Result({uuid, dateCreated, dateModified, id, firstName, lastName, email, biography, birthYear, gender, address, countryCode, country, state, city, latitude, longitude, profilepic, phoneNumber, profileVisibilityType, token, userType, roleUUID, otpVerified, isTemporaryPassword, pushNotification, emailNotification, resetPasswordToken, isPasswordAvailable, phoneDialCode, phoneCountryCode, isAutoVerified, googleUserId, linkdinUserId, appleUserId, accountType});

  Result.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    biography = json['biography'];
    birthYear = json['birthYear'];
    gender = json['gender'];
    address = json['address'];
    countryCode = json['countryCode'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    profilepic = json['profilepic'];
    phoneNumber = json['phoneNumber'];
    profileVisibilityType = json['profileVisibilityType'];
    token = json['token'];
    userType = json['userType'] != null ? UserType.fromJson(json['userType']) : null;
    roleUUID = json['roleUUID'];
    otpVerified = json['otpVerified'];
    isTemporaryPassword = json['isTemporaryPassword'];
    pushNotification = json['pushNotification'];
    emailNotification = json['emailNotification'];
    resetPasswordToken = json['resetPasswordToken'];
    isPasswordAvailable = json['isPasswordAvailable'];
    phoneDialCode = json['phoneDialCode'];
    phoneCountryCode = json['phoneCountryCode'];
    isAutoVerified = json['isAutoVerified'];
    googleUserId = json['googleUserId'];
    linkdinUserId = json['linkdinUserId'];
    appleUserId = json['appleUserId'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['biography'] = biography;
    data['birthYear'] = birthYear;
    data['gender'] = gender;
    data['address'] = address;
    data['countryCode'] = countryCode;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['profilepic'] = profilepic;
    data['phoneNumber'] = phoneNumber;
    data['profileVisibilityType'] = profileVisibilityType;
    data['token'] = token;
    if (userType != null) {
      data['userType'] = userType!.toJson();
    }
    data['roleUUID'] = roleUUID;
    data['otpVerified'] = otpVerified;
    data['isTemporaryPassword'] = isTemporaryPassword;
    data['pushNotification'] = pushNotification;
    data['emailNotification'] = emailNotification;
    data['resetPasswordToken'] = resetPasswordToken;
    data['isPasswordAvailable'] = isPasswordAvailable;
    data['phoneDialCode'] = phoneDialCode;
    data['phoneCountryCode'] = phoneCountryCode;
    data['isAutoVerified'] = isAutoVerified;
    data['googleUserId'] = googleUserId;
    data['linkdinUserId'] = linkdinUserId;
    data['appleUserId'] = appleUserId;
    data['accountType'] = accountType;
    return data;
  }
}

class UserType {
  String? uuid;
  String? userTypeName;
  String? description;

  UserType({uuid, userTypeName, description});

  UserType.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    userTypeName = json['userTypeName'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['userTypeName'] = userTypeName;
    data['description'] = description;
    return data;
  }
}
