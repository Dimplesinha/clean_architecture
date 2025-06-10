import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/chat_unread_count_model.dart';
import 'package:workapp/src/domain/models/common_model.dart';
import 'package:workapp/src/domain/models/image_model.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 10/09/24
/// @Message : [BasicDetailsScreen]

class ProfileBasicDetailsRepo {
  ProfileBasicDetailsRepo._internal();

  static ProfileBasicDetailsRepo instance = ProfileBasicDetailsRepo._internal();

  Future<ResponseWrapper<LoginModel>> getProfileBasicDetails({String userId = ''}) async {
    try {
      ResponseWrapper<dynamic> response = userId.isEmpty == true
          ? await ApiClient.instance.getApi(path: '${ApiConstant.getUserId}${AppUtils.loginUserModel?.uuid}')
          : await ApiClient.instance.getApi(path: '${ApiConstant.getUserId}$userId');

      if (response.status) {
        LoginResponse model = LoginResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model.result);
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

  Future<ResponseWrapper<ImageModel>> updateProfile(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.putApi(path: ApiConstant.imageUpload, requestBody: json);
      if (response.status) {
        ImageModel model = ImageModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<CommonModel>> sendConnectionId(Map<String, dynamic> requestBody) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.addConnectionIdToUser, requestBody: requestBody);
      if (response.status) {
        CommonModel model = CommonModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<ChatUnreadCountModel>> getChatUnreadCount() async {
    try {
      var response = await ApiClient.instance.getApi(path: ApiConstant.getChatUnreadCount);
      if (response.status) {
        ChatUnreadCountModel model = ChatUnreadCountModel.fromJson(response.responseData);
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
