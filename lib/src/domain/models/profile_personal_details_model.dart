import 'package:workapp/src/core/constants/constants.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [ProfilePersonalDetailsModel]

class ProfilePersonalDetailsModel {
  String? streetAddress;
  String? location;
  String? businessEmail;
  String? businessPhone;
  String? notification;
  String? profileVisibility;

  ProfilePersonalDetailsModel({
    this.streetAddress,
    this.location,
    this.businessEmail,
    this.businessPhone,
    this.notification,
    this.profileVisibility,
  });

  ProfilePersonalDetailsModel.fromJson(Map<String, dynamic> json) {
    streetAddress = json[ModelKeys.streetAddress];
    location = json[ModelKeys.location];
    businessEmail = json[ModelKeys.businessEmail];
    businessPhone = json[ModelKeys.businessPhone];
    notification = json[ModelKeys.notification];
    profileVisibility = json[ModelKeys.profileVisibility];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ModelKeys.streetAddress] = streetAddress;
    data[ModelKeys.location] = location;
    data[ModelKeys.businessEmail] = businessEmail;
    data[ModelKeys.businessPhone] = businessPhone;
    data[ModelKeys.notification] = notification;
    data[ModelKeys.profileVisibility] = profileVisibility;
    return data;
  }
}
