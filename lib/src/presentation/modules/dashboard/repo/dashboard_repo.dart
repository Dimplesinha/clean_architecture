import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [DashboardRepository]

class DashboardRepository {
  static final DashboardRepository _chatRepository = DashboardRepository._internal();

  DashboardRepository._internal();

  static DashboardRepository get instance => _chatRepository;

  Future<ResponseWrapper<MyListingResponse>> fetchListingData({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.homePaginated, requestBody: requestBody);
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
