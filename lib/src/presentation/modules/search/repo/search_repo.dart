import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message :

class SearchListingRepo {
  SearchListingRepo._internal();

  static SearchListingRepo instance = SearchListingRepo._internal();

  Future<ResponseWrapper<MyListingResponse>> searchListing(Map<String, dynamic> requestBody) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.searchListing, requestBody: requestBody);

      if (response.status) {
        MyListingResponse data = MyListingResponse.fromJson(response.responseData);
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
