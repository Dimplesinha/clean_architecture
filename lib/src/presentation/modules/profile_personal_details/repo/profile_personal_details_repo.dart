import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/sign_up_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';


/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 10/09/24
/// @Message : [BasicDetailsScreen]

class ProfilePersonalDetailsRepo {
  ProfilePersonalDetailsRepo._internal();

  static ProfilePersonalDetailsRepo instance = ProfilePersonalDetailsRepo._internal();

  Future<ResponseWrapper<LoginModel>> getProfilePersonalDetails() async {
    /// To be used when API is ready.
    try {
      var response = await ApiClient.instance.getApi(path: '${ApiConstant.getUserId}${AppUtils.loginUserModel?.uuid}');
      if (response.status) {
        LoginResponse model = LoginResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model.result);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<UpdateModel>> updateProfile(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.putApi(path: ApiConstant.signUp, requestBody: json);
      if (response.status) {
        UpdateModel model = UpdateModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<SuccessModel>> changeEmail(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.patchApi(path: ApiConstant.emailChange, requestBody: json);
      if (response.status) {
        SuccessModel model = SuccessModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
