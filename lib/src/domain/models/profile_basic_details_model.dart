import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/09/24
/// @Message : [ProfileBasicDetailsModel]

class ProfileBasicDetailsModel {
  String? firstName;
  String? lastName;
  String? gender;
  int? dobTimeStamp;

  ProfileBasicDetailsModel({this.firstName, this.lastName, this.gender, this.dobTimeStamp});

  ProfileBasicDetailsModel.fromJson(Map<String, dynamic> json) {
    firstName = json[ModelKeys.userId];
    lastName = json[ModelKeys.id];
    gender = json[ModelKeys.title];
    dobTimeStamp = json[ModelKeys.dobTimeStamp];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ModelKeys.userId] = firstName;
    data[ModelKeys.id] = lastName;
    data[ModelKeys.title] = gender;
    data[ModelKeys.dobTimeStamp] = dobTimeStamp;
    return data;
  }

  String get getDob => AppUtils.getDateTimeFromTimestamp(dobTimeStamp);
}
