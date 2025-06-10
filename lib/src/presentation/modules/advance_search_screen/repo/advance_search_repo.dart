import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/advance_search_model.dart';

class AdvanceSearchRepo {
  static final AdvanceSearchRepo _singleton = AdvanceSearchRepo._internal();

  AdvanceSearchRepo._internal();

  static AdvanceSearchRepo get instance => _singleton;

  //onSubmitTap() Used to call api.
  Future<ResponseWrapper<ContactModel?>?> onSubmitTap(BuildContext context, {required Map<String, dynamic> json}) async {
    try {
      var response = await ApiClient.instance.contactUsApi(
        path: ApiConstant.contactUsApi,
        requestBody: json,
        isBodyInArray: false,
      );
      if (response.status) {
        ContactModel model = ContactModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  //getAdvanceSearchData() Used to get search related data.
  Future<ResponseWrapper<AdvanceSearchModel?>?> getAdvanceSearchData({required Map<String, dynamic> json}) async {
    try {
      var response = await ApiClient.instance.advanceSearchApi(
        path: ApiConstant.advanceSearchApi,
        requestBody: json,
        isBodyInArray: false,
      );
      if (response.status) {
        AdvanceSearchModel model = AdvanceSearchModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  //deleteSearchApi() Used to delete search record.
  Future<ResponseWrapper<MyListingStatusResponse>?> deleteSearchApi({required int? itemId, required String? path, required Map<String, dynamic> json}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance.deleteSearchApi(
        requestBody: json,
        path: '$path',
        userToken: token,
      );
      if (response.status) {
        MyListingStatusResponse statusResponse = MyListingStatusResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: statusResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error boosting item: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(message: '', status: false);
    }
  }
}
