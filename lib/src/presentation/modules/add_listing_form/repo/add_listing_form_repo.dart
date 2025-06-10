import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_dynamic_form.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
import 'package:workapp/src/domain/models/currency_model.dart';
import 'package:workapp/src/domain/models/dynamic_add_listing_response_model.dart';
import 'package:workapp/src/domain/models/image_upload_response_model.dart';
import 'package:workapp/src/domain/models/upload_image_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [AddListingFormRepository]

class AddListingFormRepository {
  static final AddListingFormRepository _addListingFormRepository = AddListingFormRepository._internal();

  AddListingFormRepository._internal();

  static AddListingFormRepository get instance => _addListingFormRepository;

  Future<ResponseWrapper<DynamicAddListingResponseModel>> postAddListingData(
      {required String path, required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String userToken = user.result?.token ?? '';
      var response =
          await ApiClient.instance.postApiWithToken(path: path, requestBody: requestBody, userToken: userToken);
      if (response.status) {
        DynamicAddListingResponseModel model = DynamicAddListingResponseModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<BusinessProfileDetailResponse>> updateAddListingData(
      {required String path, required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.putApi(
        path: path,
        requestBody: requestBody,
      );
      if (response.status) {
        BusinessProfileDetailResponse model = BusinessProfileDetailResponse.fromJson(response.responseData);
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

  Future<ResponseWrapper<BusinessProfileDetailResponse?>> getBusinessProfile(String id) async {
    try {
      var response = await ApiClient.instance.getApi(
        path: '${ApiConstant.getBusinessProfileDetails}$id',
      );
      if (response.status) {
        BusinessProfileDetailResponse model = BusinessProfileDetailResponse.fromJson(response.responseData);
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

  Future<ResponseWrapper<BusinessProfileDetailResponse?>> getItemDetails(
      {required int itemId, required String apiPath}) async {
    try {
      var response = await ApiClient.instance.getApi(path: '$apiPath$itemId');
      if (response.status) {
        BusinessProfileDetailResponse model = BusinessProfileDetailResponse.fromJson(response.responseData);
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

  Future<ResponseWrapper<BusinessListModel?>> getBusinessOfCategory({required String path}) async {
    try {
      var response = await ApiClient.instance.getApi(
        path: path,
      );
      if (response.status) {
        BusinessListModel model = BusinessListModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<BusinessListModel?>> downloadResume({required String path}) async {
    try {
      var response = await ApiClient.instance.getApi(path: path).then((res) => res.responseData);
      if (response.status) {
        BusinessListModel model = BusinessListModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.messages, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.messages);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<CurrencyResponseModel?>> getCurrencyListApi() async {
    try {
      var response = await ApiClient.instance.getApi(
        path: ApiConstant.currencyListApi,
      );
      if (response.status) {
        CurrencyResponseModel model = CurrencyResponseModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<ImageUploadResponse?>> uploadImageVideo( Map<String, dynamic> request, File? renamedFile) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
     // var response = await ApiClient.instance.postApiWithToken(path: ApiConstant.imageVideoUpload,userToken: token,requestBody: request);
      var response = await ApiClient.instance.uploadFile(path: ApiConstant.dynamicFileUpload,userToken: token,requestBody: request,file: renamedFile!);
      if (response.status) {
        ImageUploadResponse model = ImageUploadResponse.fromJson(response.responseData);
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
