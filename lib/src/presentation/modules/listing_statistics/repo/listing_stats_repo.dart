
import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/statistics_insight_model.dart';
import 'package:workapp/src/domain/models/statistics_rating_model.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [ListingStatRepo]

/// The `ListingStatRepo` class provides a user interface for performing listing statistics consist of 3 tab view
/// insight, enquiry, rating.
class ListingStatRepo {
  static final ListingStatRepo _listingStatRepo = ListingStatRepo._internal();

  ListingStatRepo._internal();

  static ListingStatRepo get instance => _listingStatRepo;

  ///Fetch Enquiry list api
  Future<ResponseWrapper<EnquiryModel>> fetchEnquiryList({
    required String listingId,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      String path =
      ApiConstant.statisticsEnquiries.replaceAll('{{listingId}}', listingId);
      ResponseWrapper response = await ApiClient.instance.postApiWithToken(
        path: path,
        userToken: token,
        requestBody: requestBody,
      );
      if (response.status) {
        EnquiryModel statusResponse = EnquiryModel.fromJson(response.responseData);
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

  /// Fetch Insight Statistics
  Future<ResponseWrapper<StatisticsInsightModel>> fetchInsightStatistics({
    required String listingId,
    required String categoryId,
  }) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      String path =
          ApiConstant.statisticsInsight.replaceAll('{{listingId}}', listingId).replaceAll('{{categoryId}}', categoryId);
      ResponseWrapper response = await ApiClient.instance.getApiWithTokenRequest(path: path, userToken: token);
      if (response.status) {
        StatisticsInsightModel statusResponse = StatisticsInsightModel.fromJson(response.responseData);
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

  /// Fetch Insight Ratings
  Future<ResponseWrapper<StatisticsRatingsModel>> fetchInsightRatings({
    required String listingId,
    required String categoryId,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      String path =
          ApiConstant.statisticsRatings.replaceAll('{{listingId}}', listingId).replaceAll('{{categoryId}}', categoryId);
      ResponseWrapper response = await ApiClient.instance.postApiWithToken(
        path: path,
        userToken: token,
        requestBody: requestBody,
      );
      if (response.status) {
        StatisticsRatingsModel statusResponse = StatisticsRatingsModel.fromJson(response.responseData);
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
}
