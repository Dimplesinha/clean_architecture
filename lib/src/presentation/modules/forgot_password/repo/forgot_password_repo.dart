import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/sign_up_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 25-09-2024
/// @Message : [ForgotPasswordRepo]

class ForgotPasswordRepo {
  static final ForgotPasswordRepo _singleton = ForgotPasswordRepo._internal();

  ForgotPasswordRepo._internal();

  static ForgotPasswordRepo get instance => _singleton;

  ///Api call for forgot password otp and resend otp when timer is 00:00
  Future<ResponseWrapper<ForgotPasswordResponse>> forgotPassword(Map<String, dynamic> requestBody) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.forgetPassword,requestBody: requestBody);

      if(response.status){
        ForgotPasswordResponse data = ForgotPasswordResponse.fromJson(response.responseData);
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
/// Resend email verification Otp
  Future<ResponseWrapper<ForgotPasswordResponse>> resendEmailVerificationOtp(Map<String, dynamic> requestBody) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.resendEmailOtp,requestBody: requestBody);

      if(response.status){
        ForgotPasswordResponse data = ForgotPasswordResponse.fromJson(response.responseData);
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

  ///email verification api call when giving request body in post api call
  Future<ResponseWrapper<LoginResponse>> emailOTPVerification(Map<String, dynamic> requestBody)
  async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.otpVerify,requestBody: requestBody);

      if(response.status){
        LoginResponse data = LoginResponse.fromJson(response.responseData);
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

  Future<ResponseWrapper<ForgotPasswordResponse>> resendChangeEmailVerificationOtp() async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.resendChangeEmailOtp);

      if(response.status){
        ForgotPasswordResponse data = ForgotPasswordResponse.fromJson(response.responseData);
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

  /// Email change otp verify
  Future<ResponseWrapper<SuccessModel>> emailChangeOTPVerification(Map<String, dynamic> requestBody)
  async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.emailChangeOtp,requestBody: requestBody);

      if(response.status){
        SuccessModel data = SuccessModel.fromJson(response.responseData);
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
  Future<ResponseWrapper<VerifyModel>> emailChangeVerify(Map<String, dynamic> requestBody)
  async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.emailChangeOtpVerify,requestBody: requestBody);

      if(response.status){
        VerifyModel data = VerifyModel.fromJson(response.responseData);
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
