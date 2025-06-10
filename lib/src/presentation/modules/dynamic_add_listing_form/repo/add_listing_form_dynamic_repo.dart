import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 05/03/25
/// @Message : [AddListingDynamicFormRepository]

class AddListingDynamicFormRepository {
  static final AddListingDynamicFormRepository _addListingDynamicFormRepository =
      AddListingDynamicFormRepository._internal();

  AddListingDynamicFormRepository._internal();

  static AddListingDynamicFormRepository get instance => _addListingDynamicFormRepository;

  Future<ResponseWrapper<DynamicFormDataModel>> getDynamicFormData(int formId, {int? listingId}) async {
    try {
      var apiPath = ApiConstant.dynamicFormData.replaceAll('{formId}', formId.toString());
      Map<String, String>? queryParameters ={};
      if(listingId != null ) {
        queryParameters ={ModelKeys.listingId:listingId.toString() };
      }
      var response = await ApiClient.instance.getApi(
        path:  apiPath,
        queryParameters: queryParameters
      );
      if (response.status) {
        DynamicFormDataModel model = DynamicFormDataModel.fromJson(response.responseData);
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

/* Future<ResponseWrapper<DynamicFormDataModel>> addDynamicFormData({required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      var response = await ApiClient.instance.postJSONApiWithToken(path: ApiConstant.addDynamicFormData,userToken: token,requestBody: requestBody,isBodyInArray: true);
      if (response.status) {
        DynamicFormDataModel model = DynamicFormDataModel.fromJson(response.responseData);
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
  }*/
}
