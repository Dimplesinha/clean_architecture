import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/insight_count_model.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 27/03/25
/// @Message : [MyListingRepo]
///
/// The `MyListingRepo`  class provides a user interface for performing my listing consist of tab bar view and all item view
///with tab bar of listing insights, bookmark, rating

class MyListingRepo {
  static final MyListingRepo _myListingRepo = MyListingRepo._internal();

  MyListingRepo._internal();

  static MyListingRepo get instance => _myListingRepo;

  /// Fetch Listing Data
  Future<ResponseWrapper<MyListingResponse>?> fetchMyListingData({required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance
          .postApiWithToken(path: ApiConstant.myListingWithPagination, userToken: token, requestBody: requestBody);

      if (response.status) {
        MyListingResponse listingResponse = MyListingResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching listing data: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(message: '', status: false);
    }
  }

  ///Used in calling boost api call
  Future<ResponseWrapper<MyListingBoostResponse>?> boostMyItem(
      {required Map<String, dynamic> requestBody, required int? itemId}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance
          .putApiWithToken(path: '${ApiConstant.listingBoost}$itemId', userToken: token, requestBody: requestBody);
      if (response.status) {
        MyListingBoostResponse boostedResponse = MyListingBoostResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: boostedResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error boosting item: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }

  ///Used for bookmark n un-bookmark api call
  Future<ResponseWrapper<MyBookmarkItemResponse>?> bookmarkUnBookmarkItem(
      {required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance
          .postApiWithToken(path: ApiConstant.myListingBookmarkUnBookmark, userToken: token, requestBody: requestBody);
      if (response.status) {
        MyBookmarkItemResponse bookmarkItemResponse = MyBookmarkItemResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: bookmarkItemResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error boosting item: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }

  ///Used for bookmark n un-bookmark api call
  Future<ResponseWrapper<MyBookmarkItemResponse>?> likeUnlikeItem({required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance
          .postApiWithToken(path: ApiConstant.myListingLikeUnlike, userToken: token, requestBody: requestBody);
      if (response.status) {
        MyBookmarkItemResponse bookmarkItemResponse = MyBookmarkItemResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: bookmarkItemResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error boosting item: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }

  ///Used for changing status from active to inactive and its status change api call
  Future<ResponseWrapper<MyListingStatusResponseModel>?> statusChangeOfMyItem(
      {required Map<String, dynamic> requestBody, required int? itemId}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance
          .putApiWithToken(path: '${ApiConstant.listingStatus}$itemId', userToken: token, requestBody: requestBody);
      if (response.status) {
        MyListingStatusResponseModel statusResponse = MyListingStatusResponseModel.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: statusResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error boosting item: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }

  Future<ResponseWrapper<MyListingResponse>?> fetchMyBookmarkData({required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance.postApiWithToken(
          path: ApiConstant.myListingBookmarkWithPagination, userToken: token, requestBody: requestBody);

      if (response.status) {
        MyListingResponse listingResponse = MyListingResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching listing data: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }

  Future<ResponseWrapper<MyListingStatusResponse>?> deleteMyItem({required int? itemId, required String? path}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance.deleteApiWithToken(path: '$path$itemId', userToken: token);
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
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }
  Future<ResponseWrapper<MyListingStatusResponse>?> deleteMyWaitingItem({required int? itemId,required isHistory}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      String path = ApiConstant.deleteWaitingListingDetails
          .replaceAll('{Id}', itemId.toString())
          .replaceAll('{ishistory}', isHistory.toString());

      ResponseWrapper response = await ApiClient.instance.deleteApiWithToken(
        path: path,
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
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }
  Future<ResponseWrapper<CategoryUseCountResponse>?> usageCountMyItem(
      {required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance
          .postApiWithToken(path: ApiConstant.listingCount, userToken: token, requestBody: requestBody);
      if (response.status) {
        CategoryUseCountResponse statusResponse = CategoryUseCountResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: statusResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error boosting item: $e');
      }
      return ResponseWrapper(message: '', status: false);
    }
  }

  /// Fetch Insight data
  Future<ResponseWrapper<InsightResponseModel>> fetchInsightPaginated(
      {required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance.postApiWithToken(
        path: ApiConstant.listingInsight,
        userToken: token,
        requestBody: requestBody,
      );
      if (response.status) {
        InsightResponseModel statusResponse = InsightResponseModel.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: statusResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error boosting item: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }

  /// Fetch Insight Count data
  Future<ResponseWrapper<InsightCountModel>> fetchInsightCount({required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance.postApiWithToken(
        path: ApiConstant.insightCount,
        userToken: token,
        requestBody: requestBody,
      );
      if (response.status) {
        InsightCountModel statusResponse = InsightCountModel.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: statusResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error boosting item: $e');
      }
      // Return error in case of failure
      return ResponseWrapper(
        message: '',
        status: false,
      );
    }
  }

  Future<ResponseWrapper<RatingModel>> fetchRating(
      {required Map<String, dynamic> requestBody, required String userToken}) async {
    try {
      ResponseWrapper response = await ApiClient.instance
          .postApiWithToken(path: ApiConstant.listingMyRating, userToken: userToken, requestBody: requestBody);
      if (response.status) {
        RatingModel model = RatingModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching insight count: ${e.toString()}');
      }
      // Return failure response
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<RatingModel>> editMyRating(
      {required Map<String, dynamic> requestBody, required String userToken}) async {
    try {
      ResponseWrapper response = await ApiClient.instance
          .putApiWithToken(path: ApiConstant.listingEditMyRating, userToken: userToken, requestBody: requestBody);
      if (response.status) {
        RatingModel model = RatingModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching insight count: ${e.toString()}');
      }

      // Return failure response
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper<void>> activityTracking({required Map<String, dynamic> requestBody}) async {
    try {
      ResponseWrapper response =
          await ApiClient.instance.postApi(path: ApiConstant.activityTracking, requestBody: requestBody);
      log('response:${response.status}');
      if (response.status) {
        return ResponseWrapper(message: response.message, status: true);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: 'Failed to fetch');
    }
  }
}
