/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 24-09-2024
/// @Message : [LoginResponse]

class LoginResponse {
  int? statusCode;
  String? message;
  LoginModel? result;
  bool? isSuccess;
  String? utcTimeStamp;

  LoginResponse({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    result = json['result'] != null ? LoginModel.fromJson(json['result']) : null;
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

class LoginModel {
  int? id;
  String? uuid;
  String? dateCreated;
  String? dateModified;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? biography;
  int? birthYear;
  String? gender;
  String? address;
  String? city;
  String? state;
  String? countryName;
  double? latitude;
  double? longitude;
  String? profilepic;
  String? phoneNumber;
  int? profileVisibilityType;
  String? token;
  String? location;
  String? phoneCode;
  String? dialCode;
  UserType? userType;
  SubscriberPlan? subscriberPlan;
  bool? planPurchased;
  String? roleUUID;
  bool? otpVerified;
  bool? isTemporaryPassword;
  bool? isTrustedUser;
  String? resetPasswordToken;
  String? accountTypeValue;
  int? accountType;
  bool? isPasswordAvailable;
  String? countryPhoneCode;
  bool? isAutoVerified;
  bool? rememberMeEnabled;
  String? googleUserId;
  String? linkdinUserId;
  String? appleUserId;
  bool? emailNotification;
  bool? pushNotification;
  String? phoneDialCode;
  String? phoneCountryCode;
  int? recordStatusID;

  LoginModel({
    this.uuid,
    this.id,
    this.dateCreated,
    this.dateModified,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.biography,
    this.birthYear,
    this.gender,
    this.address,
    this.city,
    this.location,
    this.state,
    this.countryName,
    this.latitude,
    this.longitude,
    this.profilepic,
    this.phoneNumber,
    this.profileVisibilityType,
    this.token,
    this.userType,
    this.roleUUID,
    this.dialCode,
    this.phoneCode,
    this.otpVerified,
    this.isTemporaryPassword,
    this.resetPasswordToken,
    this.isPasswordAvailable,
    this.countryPhoneCode,
    this.isAutoVerified,
    this.googleUserId,
    this.linkdinUserId,
    this.pushNotification,
    this.emailNotification,
    this.appleUserId,
    this.subscriberPlan,
    this.planPurchased,
    this.accountTypeValue,
    this.accountType,
    this.rememberMeEnabled,
    this.phoneDialCode,
    this.phoneCountryCode,
    this.recordStatusID,
    this.isTrustedUser,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    biography = json['biography'];
    birthYear = json['birthYear'];
    gender = json['gender'];
    address = json['address'];
    location = json['location'];
    city = json['city'];
    dialCode = json['dialCode'];
    state = json['state'];
    countryName = json['country'];
    latitude = json['latitude'];
    dateCreated = json['dateCreated'];
    longitude = json['longitude'];
    profilepic = json['profilepic'];
    phoneNumber = json['phoneNumber'];
    phoneCode = json['phoneCode'];
    isPasswordAvailable = json['isPasswordAvailable'];
    profileVisibilityType = json['profileVisibilityType'];
    token = json['token'];
    userType = json['userType'] != null ? UserType.fromJson(json['userType']) : null;
    subscriberPlan = json['subscriberPlan'] != null ? SubscriberPlan.fromJson(json['subscriberPlan']) : null;
    planPurchased = json['planPurchased'];
    roleUUID = json['roleUUID'];
    otpVerified = json['otpVerified'];
    isTemporaryPassword = json['isTemporaryPassword'];
    resetPasswordToken = json['resetPasswordToken'];
    emailNotification = json['emailNotification'];
    pushNotification = json['pushNotification'];
    isPasswordAvailable = json['isPasswordAvailable'];
    countryPhoneCode = json['countryPhoneCode'];
    isAutoVerified = json['isAutoVerified'];
    isTrustedUser = json['isTrustedUser'];
    googleUserId = json['googleUserId'];
    linkdinUserId = json['linkdinUserId'];
    appleUserId = json['appleUserId'];
    accountType = json['accountType'];
    accountTypeValue = json['accountTypeValue'];
    rememberMeEnabled = json['rememberMeEnabled'];
    phoneDialCode = json['phoneDialCode'];
    phoneCountryCode = json['phoneCountryCode'];
    phoneCountryCode = json['phoneCountryCode'];
    recordStatusID = json['recordStatusID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['id'] = id;
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['biography'] = biography;
    data['birthYear'] = birthYear;
    data['gender'] = gender;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['dialCode'] = dialCode;
    data['country'] = countryName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['profilepic'] = profilepic;
    data['phoneCode'] = phoneCode;
    data['accountType'] = accountType;
    data['accountTypeValue'] = accountTypeValue;
    data['location'] = location;
    data['phoneNumber'] = phoneNumber;
    data['profileVisibilityType'] = profileVisibilityType;
    data['isPasswordAvailable'] = isPasswordAvailable;
    data['isTrustedUser'] = isTrustedUser;
    data['token'] = token;
    if (userType != null) {
      data['userType'] = userType!.toJson();
    }
    if (subscriberPlan != null) {
      data['subscriberPlan'] = subscriberPlan!.toJson();
    }
    data['planPurchased'] = planPurchased;
    data['roleUUID'] = roleUUID;
    data['otpVerified'] = otpVerified;
    data['isTemporaryPassword'] = isTemporaryPassword;
    data['resetPasswordToken'] = resetPasswordToken;
    data['emailNotification'] = emailNotification;
    data['pushNotification'] = pushNotification;
    data['isPasswordAvailable'] = isPasswordAvailable;
    data['countryPhoneCode'] = countryPhoneCode;
    data['isAutoVerified'] = isAutoVerified;
    data['googleUserId'] = googleUserId;
    data['linkdinUserId'] = linkdinUserId;
    data['appleUserId'] = appleUserId;
    data['rememberMeEnabled'] = rememberMeEnabled;
    data['phoneDialCode'] = phoneDialCode;
    data['phoneCountryCode'] = phoneCountryCode;
    data['recordStatusID'] = recordStatusID;

    return data;
  }

  @override
  String toString() {
    return 'LoginModel{uuid: $uuid,id: $id, dateCreated: $dateCreated, dateModified: $dateModified, firstName: $firstName, lastName: $lastName, email: $email, password: '
        '$password, biography: $biography, birthYear: ${birthYear??''}, gender: $gender, address: $address, city: $city, state: $state, countryName: $countryName, latitude: $latitude, longitude: $longitude, profilepic: $profilepic, phoneNumber: $phoneNumber, profileVisibilityType: $profileVisibilityType, token: $token, location: $location, phoneCode: $phoneCode, dialCode: $dialCode, userType: $userType, roleUUID: $roleUUID, otpVerified: $otpVerified, isTemporaryPassword: $isTemporaryPassword, isTrustedUser: $isTrustedUser, resetPasswordToken: $resetPasswordToken, accountType: $accountType, isPasswordAvailable: $isPasswordAvailable, countryPhoneCode: $countryPhoneCode, isAutoVerified: $isAutoVerified, rememberMeEnabled: $rememberMeEnabled, googleUserId: $googleUserId, linkdinUserId: $linkdinUserId, appleUserId: $appleUserId, emailNotification: $emailNotification, pushNotification: $pushNotification, phoneDialCode: $phoneDialCode, phoneCountryCode: $phoneCountryCode}';
  }

  String get getBirthYear => (birthYear == null || birthYear.toString() == '0') ? '' : birthYear.toString();

}

class Country {
  String? countryName;
  String? countryCode;
  String? countryPhoneCode;
  String? uuid;
  int? minLength;
  int? maxLength;

  Country({this.countryName, this.countryCode, this.countryPhoneCode, this.uuid, this.minLength, this.maxLength});

  Country.fromJson(Map<String, dynamic> json) {
    countryName = json['countryName'];
    countryCode = json['countryCode'];
    countryPhoneCode = json['countryPhoneCode'];
    uuid = json['uuid'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryName'] = countryName;
    data['countryCode'] = countryCode;
    data['countryPhoneCode'] = countryPhoneCode;
    data['uuid'] = uuid;
    data['minLength'] = minLength;
    data['maxLength'] = maxLength;
    return data;
  }
}

class Currency {
  String? currencyName;
  String? currencySymbol;
  String? currencyCode;
  String? uuid;

  Currency({this.currencyName, this.currencySymbol, this.currencyCode, this.uuid});

  Currency.fromJson(Map<String, dynamic> json) {
    currencyName = json['currencyName'];
    currencySymbol = json['currencySymbol'];
    currencyCode = json['currencyCode'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currencyName'] = currencyName;
    data['currencySymbol'] = currencySymbol;
    data['currencyCode'] = currencyCode;
    data['uuid'] = uuid;
    return data;
  }
}

class UserType {
  String? userTypeName;
  String? description;
  String? uuid;

  UserType({this.userTypeName, this.description, this.uuid});

  UserType.fromJson(Map<String, dynamic> json) {
    userTypeName = json['userTypeName'];
    description = json['description'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userTypeName'] = userTypeName;
    data['description'] = description;
    data['uuid'] = uuid;
    return data;
  }
}

class SubscriberPlan {
  int? subscriberId;
  int? subscriptionId;
  String? userName;
  String? email;
  int? accountType;
  String? accountTypeValue;
  String? title;
  String? countryName;
  double? price;
  int? listingLimit;
  int? boostLimit;
  int? remainingLimit;
  int? totalListingCount;
  String? recordStatus;
  String? startDate;
  String? endDate;
  int? transferLimit;
  bool? isTransferable;

  SubscriberPlan({this.subscriberId,
    this.subscriptionId,
    this.userName,
    this.email,
    this.accountType,
    this.accountTypeValue,
    this.title,
    this.countryName,
    this.price,
    this.listingLimit,
    this.boostLimit,
    this.remainingLimit,
    this.totalListingCount,
    this.recordStatus,
    this.startDate,
    this.endDate,
    this.transferLimit,
    this.isTransferable});

  SubscriberPlan.fromJson(Map<String, dynamic> json) {
    subscriberId = json['subscriberId'];
    subscriptionId = json['subscriptionId'];
    userName = json['userName'];
    email = json['email'];
    accountType = json['accountType'];
    accountTypeValue = json['accountTypeValue'];
    title = json['title'];
    countryName = json['countryName'];
    price = json['price'];
    listingLimit = json['listingLimit'];
    boostLimit = json['boostLimit'];
    remainingLimit = json['remainingLimit'];
    totalListingCount = json['totalListingCount'];
    recordStatus = json['recordStatus'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    transferLimit = json['transferLimit'];
    isTransferable = json['isTransferable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscriberId'] = subscriberId;
    data['subscriptionId'] = subscriptionId;
    data['userName'] = userName;
    data['email'] = email;
    data['accountType'] = accountType;
    data['accountTypeValue'] = accountTypeValue;
    data['title'] = title;
    data['countryName'] = countryName;
    data['price'] = price;
    data['listingLimit'] = listingLimit;
    data['boostLimit'] = boostLimit;
    data['remainingLimit'] = remainingLimit;
    data['totalListingCount'] = totalListingCount;
    data['recordStatus'] = recordStatus;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['transferLimit'] = transferLimit;
    data['isTransferable'] = isTransferable;
    return data;
  }
}
