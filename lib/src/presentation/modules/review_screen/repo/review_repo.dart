import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/data/storage/storage.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 16/09/24
/// @Message : [ReviewRepo]
///
/// The `ReviewRepo`  class provides a repo to fetch Rating of particular item

class ReviewRepo {
  static final ReviewRepo _reviewRepo = ReviewRepo._internal();

  ReviewRepo._internal();

  static ReviewRepo get instance => _reviewRepo;

  Future<ResponseWrapper<RatingListModel>> fetchRatingList({required Map<String,dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String userToken = user.result?.token ?? '';

      var response = await ApiClient.instance.postApiWithToken(path: ApiConstant.ratingList, userToken: userToken,requestBody: requestBody);

      if (response.status) {
        RatingListModel ratingListModel = RatingListModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: ratingListModel);
      } else {
        return ResponseWrapper(status: true, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching ReviewRepo: $e');
      }
      // Return failure response
      return ResponseWrapper(status: false, message: 'Failed to fetch data');
    }
  }

  Future<ResponseWrapper<ReviewListResponse>> fetchReviewList({required Map<String,dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String userToken = user.result?.token ?? '';

      var response = await ApiClient.instance.postApiWithToken(path: ApiConstant.reviewList, userToken: userToken,requestBody: requestBody);

      if (response.status) {
        ReviewListResponse ratingListModel = ReviewListResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: ratingListModel);
      } else {
        return ResponseWrapper(status: true, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching ReviewRepo: $e');
      }
      // Return failure response
      return ResponseWrapper(status: false, message: 'Failed to fetch data');
    }
  }

  Future<ResponseWrapper<RatingModel>> addRatingReview({required Map<String,dynamic> requestBody,required int ratingId}) async {
    try {
      if(ratingId == 0){
        var response = await ApiClient.instance.postApi(path:ApiConstant.addEditrating, requestBody: requestBody);
        if (response.status) {
          RatingModel ratingListModel = RatingModel.fromJson(response.responseData);
          return ResponseWrapper(status: true, message: response.message, responseData: ratingListModel);
        } else {
          return ResponseWrapper(status: true, message: response.message);
        }
      }
      else{
        var response = await ApiClient.instance.putApi(path: '${ApiConstant.addEditrating}/$ratingId', requestBody: requestBody);
        if (response.status) {
          RatingModel ratingListModel = RatingModel.fromJson(response.responseData);
          return ResponseWrapper(status: true, message: response.message, responseData: ratingListModel);
        } else {
          return ResponseWrapper(status: true, message: response.message);
        }
      }



    } catch (e) {
      if (kDebugMode) {
        print('Error fetching ReviewRepo: $e');
      }
      // Return failure response
      return ResponseWrapper(status: false, message: 'Failed to fetch data');
    }
  }
}
