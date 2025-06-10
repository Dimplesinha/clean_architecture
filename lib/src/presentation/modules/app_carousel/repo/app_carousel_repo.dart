import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [AppCarouselRepository]

class AppCarouselRepository {
  static final AppCarouselRepository _chatRepository = AppCarouselRepository._internal();

  AppCarouselRepository._internal();

  static AppCarouselRepository get instance => _chatRepository;

  Future<ResponseWrapper<MyListingResponse>> fetchListingData({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.homePremiumListings, requestBody: requestBody);
      if (response.status) {
        MyListingResponse listingResponse = MyListingResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(message: response.message, status: false);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching listing data: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
