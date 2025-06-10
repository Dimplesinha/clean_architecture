import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_sub_account_model.dart';
import 'package:workapp/src/domain/models/otp_verify_model.dart';

class OtpVerifyRepository {
  static final OtpVerifyRepository _singleton = OtpVerifyRepository._internal();

  OtpVerifyRepository._internal();

  static OtpVerifyRepository get instance => _singleton;

  Future<ResponseWrapper<OtpVerifyModel>> otpVerification(Map<String, dynamic> requestBody) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.subAccountOtpVerify, requestBody: requestBody);

      if (response.status) {
        OtpVerifyModel data = OtpVerifyModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<AddSubAccountModel>> resendOtp(Map<String, dynamic> requestBody) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.resendSubAccountOtp, requestBody: requestBody);

      if (response.status) {
        AddSubAccountModel data = AddSubAccountModel.fromJson(response.responseData);
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
