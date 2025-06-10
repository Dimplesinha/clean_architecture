import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/constants/model_keys.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/models/add_contact.dart';
import 'package:workapp/src/domain/models/block_unblock_model.dart';
import 'package:workapp/src/domain/models/chat/chat_result_common_model.dart';
import 'package:workapp/src/domain/models/chat_detail_model.dart';
import 'package:workapp/src/domain/models/chat_model.dart';
import 'package:workapp/src/domain/models/message_info_model.dart';
import 'package:workapp/src/domain/models/send_message_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/message_chat/repo/message_chat_repo.dart';

part 'message_chat_state.dart';

// MessageChatCubit manages the state and business logic for chat functionality
class MessageChatCubit extends Cubit<MessageChatState> {
  MessageChatCubit() : super(const MessageChatState());

  // Global lists to store chat messages and details
  final List<ChatResultCommonModel> globalMessageList = [];
  ChatDetailResult? globalChatDetailResult = ChatDetailResult();

  /// Fetches chat messages/conversations for a specific user
  /// [receiverId] - ID of the message receiver
  /// [lastMessageId] - ID of the last message for pagination
  /// [messageListId] - ID of the message list
  /// [isLoadMore] - Flag to determine if loading more messages
  Future<void> fetchChat(
      {required int? receiverId,
      required int? lastMessageId,
      required int? messageListId,
      bool isLoadMore = false,
      int currentPage = 0}) async {
    try {
      // Increment page number for pagination
      var index = currentPage;
      index = index + 1;
      emit(state.copyWith(
        loader: true,
        currentPage: index,
      ));

      // Prepare request body for API call
      Map<String, dynamic> requestBody = {
        ModelKeys.receiverId: receiverId,
        ModelKeys.messageListId: messageListId,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.lastMessageId: lastMessageId
      };

      // Fetch conversations from repository
      var response = await MessageChatRepository.instance.fetchUserConversations(requestBody: requestBody);

      // Process response data
      final newItems = response.responseData?.result?.messages?[0].items ?? [];
      if (isLoadMore) {
        if (globalMessageList.isNotEmpty) {
          print('globalMessageList.length: ${globalMessageList.length - 1}');
          globalMessageList.insertAll(globalMessageList.length, newItems);
        } else {
          globalMessageList.clear();
          globalMessageList.addAll(newItems);
        }
      } else {
        globalMessageList.clear();
        globalMessageList.addAll(newItems);
      }

      final totalCount = response.responseData?.result?.messages?[0].count ?? 0;

      // Calculate pagination details
      final totalPages = (totalCount / AppConstants.pageSize).ceil();
      final hasMoreItems = index < totalPages;

      var user = await PreferenceHelper.instance.getUserData();
      if (globalMessageList.isNotEmpty &&
          globalMessageList[0].senderId != user.result?.id &&
          globalMessageList.isNotEmpty) {
        markAsReadMessage(messageListId: messageListId, latestMessageId: globalMessageList[0].messageId);
      }

      // Update state based on response
      if (response.status == true && response.responseData != null) {
        emit(state.copyWith(
          messages: globalMessageList,
          chatResult: response.responseData?.result,
          loader: false,
          currentPage: index,
          hasMoreItems: hasMoreItems,
        ));
      } else {
        emit(state.copyWith(
          loader: false,
          messages: globalMessageList,
          chatResult: response.responseData?.result,
          currentPage: index,
          hasMoreItems: hasMoreItems,
        ));
      }
    } catch (e) {
      // Handle errors by disabling loader
      emit(state.copyWith(loader: false));
    }
  }

  /// Marks messages as read
  /// [messageListId] - ID of the message list to mark as read
  /// [latestMessageId] - ID of the latest message
  Future<void> markAsReadMessage({required int? messageListId, required int? latestMessageId}) async {
    try {
      // Prepare request body
      Map<String, dynamic> requestBody = {
        ModelKeys.messageListId: messageListId,
        ModelKeys.latestMessageId: latestMessageId,
      };

      // Call repository to mark messages as read
      var response = await MessageChatRepository.instance.markAsReadUserConversations(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        // Update state with new read status
        emit(state.copyWith(markAsReadMessage: response.responseData?.result, messages: globalMessageList));
      } else {
        emit(state.copyWith(markAsReadMessage: response.responseData?.result));
      }
    } catch (e) {
      // Handle errors silently
    }
  }

  Future<void> updateMessageReadStatus() async {
    emit(state.copyWith(
      loader: true,
    ));

    // Update message status in global list
    for (int i = 0; i < globalMessageList.length; i++) {
      if (globalMessageList[i].messageStatusId != MessageStatus.read.value) {
        globalMessageList[i].messageStatusId = MessageStatus.read.value;
      }
    }

    emit(state.copyWith(loader: false, messages: globalMessageList));
  }

  /// Blocks or unblocks a user
  /// [receiverId] - ID of the user to block/unblock
  /// [isBlock] - True to block, false to unblock
  /// [callback] - Function to handle the result
  Future<void> blockUnBlockUser({
    required int? receiverId,
    required bool? isBlock,
  }) async {
    try {
      emit(state.copyWith(loader: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.blockedUserId: receiverId,
        ModelKeys.isBlock: isBlock,
      };

      var response = await MessageChatRepository.instance.blockUnBlockUser(requestBody: requestBody);

      // Update state and call callback based on response
      if (response.status == true && response.responseData != null) {
        /*globalChatDetailResult = ChatDetailResult(
          isAddedInContact: state.chatDetailResult?.isAddedInContact,
          isBlockedByMe: isBlock,
          isBlockedByUser: state.chatDetailResult?.isBlockedByUser,
        );*/
        globalChatDetailResult?.isAddedInContact = state.chatDetailResult?.isAddedInContact;
        globalChatDetailResult?.isBlockedByMe = isBlock;
        globalChatDetailResult?.isBlockedByUser = state.chatDetailResult?.isBlockedByUser;
        // chatDetail(otherUserId: receiverId);
        emit(state.copyWith(loader: false, chatDetailResult: globalChatDetailResult));
      } else {
        emit(state.copyWith(loader: false));
      }
    } catch (e) {
      emit(state.copyWith(loader: false));
    }
  }

  /// Updates the blocked status of a user in the chat detail state.
  ///
  /// This method is called when a block/unblock action is performed,
  /// and ensures that the UI reflects the new block/unblock status.
  ///
  /// [result] contains the block status and the user ID.
  /// [receiverId] is the ID of the user with whom the chat is taking place.
  Future<void> updateBlockedStatus(BlockUnBlockResult result, int? receiverId) async {
    // Check if the result corresponds to the current chat receiver
    if (result.userId == receiverId) {
      // Update the global chat detail with the new block status
      globalChatDetailResult = ChatDetailResult(
        isAddedInContact: state.chatDetailResult?.isAddedInContact,
        isBlockedByMe: state.chatDetailResult?.isBlockedByMe,
        isDeleted: state.chatDetailResult?.isDeleted,
        isDeletedItemListId: state.chatDetailResult?.isDeletedItemListId,
        isBlockedByUser: result.isBlock, // Set the updated block status
      );

      /* globalChatDetailResult?.isAddedInContact = state.chatDetailResult?.isAddedInContact;
      globalChatDetailResult?.isBlockedByMe = state.chatDetailResult?.isBlockedByMe;
      globalChatDetailResult?.isBlockedByUser = result.isBlock; // Set the updated block status*/


      // Emit the updated state to rebuild the UI with the latest info
      emit(state.copyWith(chatDetailResult: globalChatDetailResult));
    }
  }

  /// Adds a user to contacts from chat
  /// [otherUserId] - ID of the user to add
  /// [callback] - Function to handle the result
  Future<AddToContactModel?> addToContactFromChat({
    required int? otherUserId,
  }) async {
    try {
      emit(state.copyWith(loader: true));

      Map<String, dynamic> requestBody = {ModelKeys.otherUserId: otherUserId};

      var response = await MessageChatRepository.instance.addToContactFromChat(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        globalChatDetailResult = state.chatDetailResult;
        globalChatDetailResult?.isAddedInContact = true;

        // AppUtils.showSnackBar(response.message, SnackBarType.success);
        emit(state.copyWith(loader: false, chatDetailResult: globalChatDetailResult));
        return response.responseData;
      } else {
        //  AppUtils.showSnackBar('Error occurred: ${response.message}', SnackBarType.fail);
        emit(state.copyWith(loader: false));
        return null;
      }
    } catch (e) {
      // AppUtils.showSnackBar('Operation failed', SnackBarType.fail);
      emit(state.copyWith(loader: false));
      return null;
    }
  }

  /// Fetches chat details for a specific user
  /// [otherUserId] - ID of the user to get details for
  Future<void> chatDetail({required int? otherUserId,required int? itemListId}) async {
    try {
      emit(state.copyWith(loader: true));

      Map<String, String> requestBody = {ModelKeys.otherUserId: '$otherUserId',ModelKeys.itemListId: '${itemListId ?? 0}'};

      var response = await MessageChatRepository.instance.messageDetail(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        globalChatDetailResult = response.responseData?.result;
        emit(state.copyWith(loader: false, chatDetailResult: response.responseData?.result));
      } else {
        emit(state.copyWith(loader: false, chatDetailResult: response.responseData?.result));
      }
    } catch (e) {
      emit(state.copyWith(loader: false));
    }
  }

  /// Sends a new message
  /// [receiverId] - ID of the message receiver
  /// [messageContent] - Content of the message
  Future<void> sendMessage({
    required int? receiverId,
    required String? messageContent,
    required int? messageListId,
    required int? itemListId,
  }) async {
    try {
      emit(state.copyWith(loader: true));

      DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.SS');
      var sendTime = formatter.format(DateTime.now());
      var user = await PreferenceHelper.instance.getUserData();

      // Prepare message data
      Map<String, dynamic> requestBody = {
        ModelKeys.senderId: user.result?.id,
        ModelKeys.receiverId: receiverId ?? '',
        ModelKeys.groupId: 0,
        ModelKeys.messageContent: messageContent,
        ModelKeys.mediaTypeId: MediaType.text.value,
        ModelKeys.mediaUrl: '',
        ModelKeys.sentAt: sendTime,
        ModelKeys.messageStatusId: MessageStatus.sent.value,
        ModelKeys.messageListId: messageListId,
        ModelKeys.itemListId: itemListId,
      };

      var response = await MessageChatRepository.instance.sendMessage(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        var result = response.responseData?.result;
        globalMessageList.insert(0, result ?? ChatResultCommonModel());
        if(response.responseData?.statusCode==403){
          AppUtils.showSnackBar(response.message, SnackBarType.fail);
          AppRouter.pop(res: true);

        }
        emit(state.copyWith(loader: false, messages: globalMessageList));
      } else {
        emit(state.copyWith(loader: false));
      }
    } catch (e) {
      emit(state.copyWith(loader: false));
    }
  }

  /// Fetches information about a specific message
  /// [messageId] - ID of the message to get info for
  Future<void> messageInfo({required String? messageId}) async {
    try {
      emit(state.copyWith(loader: true));

      Map<String, String> requestBody = {ModelKeys.messageId: messageId ?? ''};

      var response = await MessageChatRepository.instance.messageInfo(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        emit(state.copyWith(loader: false, messageInfoResult: response.responseData?.result));
      } else {
        emit(state.copyWith(loader: false, messageInfoResult: response.responseData?.result));
      }
    } catch (e) {
      emit(state.copyWith(loader: false));
    }
  }

  /// Updates the message list with an incoming message
  /// [message] - The incoming message to add
  Future<void> updateIncomingMessageToList(
      {required ChatResultCommonModel message, required int? messageListId, required int? latestMessageId}) async {
    emit(state.copyWith(loader: true));
    globalMessageList.insert(0, message);
    emit(state.copyWith(loader: false, messages: globalMessageList));
    markAsReadMessage(messageListId: messageListId, latestMessageId: latestMessageId);
  }

  /// Updates typing status in the chat
  /// [typingStatus] - The current typing status
  Future<void> messageTypingStatus({required TypingStatusModel typingStatus}) async {
    emit(state.copyWith(loader: false, typingStatusModel: typingStatus));
  }

  /// Deletes a specific message
  /// [receiverId] - ID of the message receiver
  /// [messageId] - ID of the message to delete
  /// [index] - Index of the message in the list
  Future<void> deleteParticularMessage({required int? receiverId, int? messageId = 0, required int index}) async {
    try {
      emit(state.copyWith(loader: true));

      var user = await PreferenceHelper.instance.getUserData();
      Map<String, dynamic> requestBody = {
        ModelKeys.senderId: user.result?.id,
        ModelKeys.messageId: messageId,
        if (messageId != 0) ModelKeys.receiverId: receiverId,
      };

      var response = await MessageChatRepository.instance.deleteChat(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        globalMessageList.removeAt(index);
        emit(state.copyWith(loader: false, messages: globalMessageList));
      } else {
        emit(state.copyWith(loader: false));
      }
    } catch (e) {
      emit(state.copyWith(loader: false));
    }
  }

  /// Toggles the expansion state of a carousel tile
  void onTileExpansionChanged() {
    emit(state.copyWith(isCarouselExpanded: !state.isCarouselExpanded));
  }

  Future<void> spamUserReport(
      { required String? userId, required int? reportType, required String? comment}) async {
    try {
      Map<String, dynamic> requestBody = {
        ModelKeys.userId: userId,
        ModelKeys.reportTypeId: reportType,
        ModelKeys.comment: comment,
      };
      var response = await MessageChatRepository.instance.spamUserReport(requestBody: requestBody);
      if (response.status == true && response.responseData != null) {
        AppRouter.pop();
        AppRouter.pop();
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        AppRouter.pop();
        AppRouter.pop();
        AppUtils.showErrorSnackBar(response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(this);
      }
    }
  }


  /// Sets the loading state
  /// [loader] - Boolean to show/hide loader
  Future<void> setLoader(bool loader) async {
    emit(state.copyWith(loader: loader));
  }
}
