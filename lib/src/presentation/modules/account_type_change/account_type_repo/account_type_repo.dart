import 'package:flutter/foundation.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/domain/models/sign_up_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [AccountTypeRepo]

class AccountTypeRepo {
  static final AccountTypeRepo _accountTypeRepo = AccountTypeRepo._internal();

  AccountTypeRepo._internal();

  static AccountTypeRepo get instance => _accountTypeRepo;

  Future<ResponseWrapper<VerifyModel>> selectAccountType(
      Map<String, dynamic> json) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      var response = await ApiClient.instance
          .putApiWithToken(path: ApiConstant.accountType, requestBody: json, userToken: token);
      if (response.status) {
        VerifyModel model = VerifyModel.fromJson(response.responseData);
        return ResponseWrapper(
            status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(
          status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<ActiveListingModel>> activeListingCount(
      Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance
          .postApi(path: ApiConstant.activeListingCount, requestBody: json);
      if (response.status) {
        ActiveListingModel model =
            ActiveListingModel.fromJson(response.responseData);
        return ResponseWrapper(
            status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(
          status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<MyListingResponse>> activeListingList(
      Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance
          .postApi(path: ApiConstant.activeListingList, requestBody: json);
      if (response.status) {
        MyListingResponse model =
            MyListingResponse.fromJson(response.responseData);
        return ResponseWrapper(
            status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(
          status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<VerifyModel>> changeAccountType(
      Map<String, dynamic> json, int accountType) async {
    try {
      var response = await ApiClient.instance.putApi(
          path: ApiConstant.changeAccountType
              .replaceAll('{accountType}', accountType.toString()),
          requestBody: json);
      if (response.status) {
        VerifyModel model = VerifyModel.fromJson(response.responseData);
        return ResponseWrapper(
            status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(
          status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
