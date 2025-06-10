import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/add_contact.dart';
import 'package:workapp/src/domain/models/block_unblock_model.dart';
import 'package:workapp/src/domain/models/chat_detail_model.dart';
import 'package:workapp/src/domain/models/delete_chat_model.dart';
import 'package:workapp/src/domain/models/mark_as_read_model.dart';
import 'package:workapp/src/domain/models/message_info_model.dart';

import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/domain/models/send_message_model.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 16/09/24
/// @Message : [MessageChatRepository]

class MessageChatRepository {
  static final MessageChatRepository _messageChatRepository = MessageChatRepository._internal();

  MessageChatRepository._internal();

  static MessageChatRepository get instance => _messageChatRepository;

  Future<ResponseWrapper<ChatModel>> fetchUserConversations({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(requestBody: requestBody, path: ApiConstant.chatHistory);
      if (response.status) {
        ChatModel model = ChatModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<MarkAsReadModel>> markAsReadUserConversations({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(requestBody: requestBody, path: ApiConstant.markMessagesRead);
      if (response.status) {
        MarkAsReadModel model = MarkAsReadModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<BlockUnBlockModel>> blockUnBlockUser({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(requestBody: requestBody, path: ApiConstant.blockUnBlockUser);
      if (response.status) {
        BlockUnBlockModel model = BlockUnBlockModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<DeleteChatModel>> deleteChat({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(requestBody: requestBody, path: ApiConstant.deleteChat);
      if (response.status) {
        DeleteChatModel model = DeleteChatModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<AddToContactModel>> addToContactFromChat({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(requestBody: requestBody, path: ApiConstant.addToContact);
      if (response.status) {
        AddToContactModel model = AddToContactModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<ChatDetailModel>> messageDetail({required Map<String, String> requestBody}) async {
    try {
      var response = await ApiClient.instance.getApi(queryParameters: requestBody, path: ApiConstant.messageDetail);
      if (response.status) {
        ChatDetailModel model = ChatDetailModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<SendMessageModel>> sendMessage({required Map<String, dynamic> requestBody}) async {
    try {
      var response = await ApiClient.instance.postApi(requestBody: requestBody, path: ApiConstant.sendMessage);
      if (response.status) {
        SendMessageModel model = SendMessageModel.fromJson(response.responseData);
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

  Future<ResponseWrapper<MessageInfoModel>> messageInfo({required Map<String, String> requestBody}) async {
    try {
      var response = await ApiClient.instance.getApi(queryParameters: requestBody, path: ApiConstant.getMessageInfo);
      if (response.status) {
        MessageInfoModel model = MessageInfoModel.fromJson(response.responseData);
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
}
