import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
import 'package:workapp/src/domain/models/deep_link_response.dart';
import 'package:workapp/src/domain/models/dynamic_listing_detail_model.dart';
import 'package:workapp/src/domain/models/models_export.dart';

import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message : [ItemDetailsRepo]

///This repo is used for api call for item details screen
class ItemDetailsRepo {
  ItemDetailsRepo._internal();

  static ItemDetailsRepo instance = ItemDetailsRepo._internal();

  Future<ResponseWrapper<MyListingResponse>?> fetchRelatedListing({required Map<String, dynamic> requestBody}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance
          .postApiWithToken(path: ApiConstant.relatedItemList, userToken: token, requestBody: requestBody);
      if (response.status) {
        MyListingResponse listingResponse = MyListingResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: 'Failed to fetch');
    }
  }

  /// Api call for item detail
  Future<ResponseWrapper<DynamicListingDetailModel?>> getDynamicListingItemDetails({
    required int? itemId,
    required String? apiPath,
  }) async {
    try {
      var response = await ApiClient.instance.getApi(path: '${ApiConstant.getListingDetails}$itemId');
      if (response.status) {
        DynamicListingDetailModel model = DynamicListingDetailModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<RatingModel>> spamItemReport({required Map<String, dynamic> requestBody}) async {
    try {
      ResponseWrapper response = await ApiClient.instance.postApi(path: ApiConstant.spamItem, requestBody: requestBody);
      if (response.status) {
        RatingModel listingResponse = RatingModel.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: 'Failed to fetch');
    }
  }

  Future<ResponseWrapper<RatingModel>> spamUserReport({required Map<String, dynamic> requestBody}) async {
    try {
      ResponseWrapper response = await ApiClient.instance.postApi(path: ApiConstant.spamUser, requestBody: requestBody);
      if (response.status) {
        RatingModel listingResponse = RatingModel.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: 'Failed to fetch');
    }
  }

  Future<ResponseWrapper<DeepLinkResponse>> encodeLink(int listingID) async {
    try {
      ResponseWrapper response = await ApiClient.instance.getApi(path: '${ApiConstant.encodeLink}$listingID');
      if (response.status) {
        DeepLinkResponse listingResponse = DeepLinkResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: 'Failed to fetch');
    }
  }

  Future<ResponseWrapper<DeepLinkResponse>> decodeLink(String listingIDCode) async {
    try {
      ResponseWrapper response = await ApiClient.instance.getApi(path: '${ApiConstant.decodeLink}$listingIDCode');
      if (response.status) {
        DeepLinkResponse listingResponse = DeepLinkResponse.fromJson(response.responseData);
        return ResponseWrapper(message: response.message, status: true, responseData: listingResponse);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      return ResponseWrapper(status: false, message: 'Failed to fetch');
    }
  }
}
