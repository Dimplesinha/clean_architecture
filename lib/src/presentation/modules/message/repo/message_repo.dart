import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/chat_list_model.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/domain/models/my_contact_status_model.dart';
import 'package:workapp/src/domain/models/my_contacts_model.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [ChatRepository]

class ChatRepository {
  static final ChatRepository _chatRepository = ChatRepository._internal();

  ChatRepository._internal();

  static ChatRepository get instance => _chatRepository;

  Future<ResponseWrapper<ChatListModel>> fetchUserConversations({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(requestBody: requestBody, path: ApiConstant.chatListing);
      if (response.status) {
        ChatListModel model = ChatListModel.fromJson(response.responseData);
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

  /// Fetch contact Listing Data
  Future<ResponseWrapper<MyContactResponse>?> fetchContactList({Map<String, dynamic>? requestBody}) async {
    try {
      ResponseWrapper response =
          await ApiClient.instance.postApi(path: ApiConstant.contactList, requestBody: requestBody);
      if (response.status) {
        MyContactResponse listingResponse = MyContactResponse.fromJson(response.responseData);
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

  Future<ResponseWrapper<MyContactStatusResponse>?> deleteContact({required int? itemId, required String? path}) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';
      ResponseWrapper response = await ApiClient.instance.deleteApiWithToken(path: '$path$itemId', userToken: token);
      if (response.status) {
        MyContactStatusResponse statusResponse = MyContactStatusResponse.fromJson(response.responseData);
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
