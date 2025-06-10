import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 27-09-2024
/// @Message : [NewPasswordRepo]

class NewPasswordRepo {
  static final NewPasswordRepo _singleton = NewPasswordRepo._internal();

  NewPasswordRepo._internal();

  static NewPasswordRepo get instance => _singleton;

  Future<ResponseWrapper<ResetPasswordResponse>> resetNewPassword({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.resetPassword, requestBody: requestBody);

      if (response.status) {
        ResetPasswordResponse data = ResetPasswordResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: data);
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

  Future<ResponseWrapper<ResetPasswordResponse>> setNewPassword({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.patchApi(path: ApiConstant.passwordSet, requestBody: requestBody);

      if (response.status) {
        ResetPasswordResponse data = ResetPasswordResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: data);
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
