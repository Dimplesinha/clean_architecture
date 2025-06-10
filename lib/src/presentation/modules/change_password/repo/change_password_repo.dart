import 'package:flutter/foundation.dart';

import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';

import 'package:workapp/src/core/constants/api_constants.dart';

class ChangePasswordRepo {
  static final ChangePasswordRepo _singleton = ChangePasswordRepo._internal();

  ChangePasswordRepo._internal();

  static ChangePasswordRepo get instance => _singleton;

  ///Change Password Api call using ApiClient with patchApi call using ResponseWrapper and adding response to change Password response model.
  Future<ResponseWrapper<ChangePasswordResponse>> changePassword(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.patchApi(path: ApiConstant.changePassword, requestBody: json);
      if (response.status) {
        ChangePasswordResponse model = ChangePasswordResponse.fromJson(response.responseData);
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
  Future<ResponseWrapper<ChangePasswordResponse>> setPassword(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.patchApi(path: ApiConstant.passwordSet, requestBody: json);
      if (response.status) {
        ChangePasswordResponse model = ChangePasswordResponse.fromJson(response.responseData);
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
