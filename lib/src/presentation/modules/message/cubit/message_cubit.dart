import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/core/constants/model_keys.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/models/chat/chat_result_common_model.dart';
import 'package:workapp/src/domain/models/chat/report_type_list.dart';
import 'package:workapp/src/domain/models/chat_list_model.dart';
import 'package:workapp/src/domain/models/my_contacts_model.dart';
import 'package:workapp/src/domain/models/send_message_model.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/message/repo/message_repo.dart';
import 'package:workapp/src/presentation/modules/message_chat/repo/message_chat_repo.dart';
import 'package:workapp/src/utils/signalr_helper.dart';

part 'message_state.dart';

/// Manages the state and business logic for message-related operations.
///
/// Responsibilities:
/// - Fetches and manages the list of user conversations
/// - Handles pagination and search functionality
/// - Updates UI state based on data fetching results
///
class MessageCubit extends Cubit<MessageState> {
  // Controller for handling search input
  final searchTxtController = TextEditingController();

  // Global list to store chat conversations
  final List<ChatListResult> globalChatList = [];

  // Tracks the current page for contact list pagination
  int contactCurrentPage = 1;
  int currentPage = 1;

  // Indicates if there are more contact pages to load
  bool hasNextPage = true;

  Function()? updateChatUnreadCount;

  /// Initializes the cubit with the default [MessageState].
  MessageCubit() : super(MessageState());

  /// Fetches conversation items from the repository.
  ///
  /// [isLoadMore]: Indicates if this is a pagination request to load more items.
  Future<void> fetchItems({bool isLoadMore = false}) async {
    try {
      if (AppUtils.loginUserModel?.uuid == null) {
        return;
      }
      // Calculate page number based on whether we're loading more items
     // var currentPage = isLoadMore ? (state.currentPage ?? 0) + 1 : 1;


      // Show loader and update pagination state
      emit(state.copyWith(loader: true,));

      // Prepare API request parameters
      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
        ModelKeys.search: searchTxtController.text,
      };

      // Fetch conversations from the repository
      var response = await ChatRepository.instance
          .fetchUserConversations(requestBody: requestBody);

      // Process response data
      final newItems = response.responseData?.result?[0].items ?? [];
      final totalCount = response.responseData?.result?[0].count ?? 0;


   /*   // Calculate pagination status
      final totalPages = (totalCount / AppConstants.pageSize).ceil();
      final hasMoreItems = currentPage < totalPages;
*/
      var updatedListingItems = currentPage == 1 ? newItems : [...state.messages, ...newItems];


      if (totalCount != updatedListingItems.length) {
        hasNextPage = true;
        currentPage++;
      } else {
        hasNextPage = false;
      }

      // Update state with new data
      emit(state.copyWith(
        loader: false,
        messages: updatedListingItems,
        currentPage: currentPage,
        hasMoreItems: hasNextPage,
      ));

      // Update global chat list
      globalChatList.clear();
      globalChatList.addAll(updatedListingItems);

    } catch (e) {
      // Handle errors, preserving existing messages if loading more
      emit(state.copyWith(
        loader: false,
        messages: isLoadMore ? state.messages : [],
        hasMoreItems: false,
      ));
    }
  }

  /// Deletes an entire chat conversation
  ///
  /// [receiverId]: ID of the chat recipient
  /// [messageListId]: ID of the message list to delete
  Future<void> deleteEntireChat({
    required int? receiverId,
    required int? messageListId,
  }) async {
    try {
      var user = await PreferenceHelper.instance.getUserData();
      Map<String, dynamic> requestBody = {
        ModelKeys.senderId: user.result?.id,
        ModelKeys.receiverId: receiverId,
        ModelKeys.messageListId: messageListId,
        ModelKeys.messageId: 0
      };

      var response = await MessageChatRepository.instance
          .deleteChat(requestBody: requestBody);

      if (response.status == true && response.responseData != null) {
        fetchItems();

        emit(state.copyWith(messages: globalChatList, isChatDeleted: true));
      } else {
        emit(state.copyWith(loader: false, isChatDeleted: false));
      }
    } catch (e) {
      emit(state.copyWith(loader: false));
    }
  }

  /// Updates the chat list with a new incoming message
  ///
  /// [message]: The incoming message to update the list with
  Future<void> updateIncomingMessageToList({required ChatResultCommonModel message}) async {
    // Update existing chat with new latest message
    emit(state.copyWith(loader: true));
    for (int i = 0; i < globalChatList.length; i++) {
      bool exists = globalChatList.any((chat) => chat.messageListId == message.messageListingId);
      if (exists) {
        if (message.messageListingId == globalChatList[i].messageListId) {
          int? unreadCount = globalChatList[i].unreadCount ?? 0;
          globalChatList[i].unreadCount = unreadCount + 1;
          globalChatList[i].latestMessage = message;
          break;
        } else {
          fetchItems();
        }
      }
      else{
        fetchItems();
      }
    }
    emit(state.copyWith(loader: false, messages: globalChatList));
  }

  void calculateTotalUnreadAndNotify() {
    fetchItems();
    final totalUnread = globalChatList.fold<int>(
      0,
          (sum, chat) => sum + (chat.unreadCount??0),
    );

    SignalRHelper.instance.updateUnreadMessageCount(totalUnread);
  }


  Future<void> updateUnreadCount({required int? messageListId,}) async {
    emit(state.copyWith(loader: true));
    for (int i = 0; i < globalChatList.length; i++) {
      if (messageListId == globalChatList[i].messageListId) {
        globalChatList[i].unreadCount = 0;
        break;
      }
    }
    emit(state.copyWith(loader: false, messages: globalChatList));
  }

  /// Updates typing status in the chat
  /// [typingStatus] - The current typing status
  Future<void> messageTypingStatus({required TypingStatusModel typingStatus}) async {
    emit(state.copyWith(loader: false, typingStatusModel: typingStatus));
  }

  /// Updates the selected tab index in the state
  ///
  /// [index]: The index of the selected tab
  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  /// Refreshes the current state without data changes
  ///
  /// Useful for triggering UI rebuilds or resetting certain flags
  void refreshState() {
    emit(state.copyWith(unreadCount: 0, isChatDeleted: false));
  }

  /// Fetches the contact list with pagination support
  ///
  /// [isRefresh]: Whether to refresh the entire list
  /// [isSwipe]: Indicates if triggered by swipe refresh
  /// [selectedIndex]: Optional tab index
  /// [loader]: Optional loader state
  /// [currentPage]: Optional page number
  /// [hasMoreItems]: Optional pagination flag
  Future<void> fetchContactList({
    bool isRefresh = false,
    isSwipe = false,
    int? selectedIndex,
    bool? loader,
    int? currentPage,
    bool? hasMoreItems,
  }) async {
    try {
      // Show loader only if not already loading and not swipe refresh
      if(AppUtils.loginUserModel?.uuid == null) {
       return;
      }
      if (state.loader == false) {
        if (isRefresh == true && isSwipe == false) {
          emit(state.copyWith(loader: true));
        }
      }

      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: contactCurrentPage,
        ModelKeys.pageSize: AppConstants.contactPageSize,
        ModelKeys.search: '',
      };

      var response = await ChatRepository.instance
          .fetchContactList(requestBody: requestBody);

      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        // Flatten and cast contact items
        List<Contact> myListingItem = (response?.responseData?.result
            .expand((model) => model.items)
            .toList() ?? [])
            .cast<Contact>();

        // Update pagination status
        if (myListingItem.length == AppConstants.contactPageSize) {
          hasNextPage = true;
          contactCurrentPage++;
        } else {
          hasNextPage = false;
        }

        // Combine new items with existing ones if not refreshing
        List<Contact> updatedMyListingItems = isRefresh
            ? myListingItem
            : [...?state.myListingItem, ...myListingItem];

        emit(state.copyWith(
          myListing: response?.responseData?.result[0].items,
          myListingItem: updatedMyListingItems,
          loader: false,
        ));
      } else {
        emit(state.copyWith(loader: false, myListingItem: []));
      }
    } catch (e) {
      emit(state.copyWith(loader: false, myListingItem: []));
    }
  }

  /// Deletes a contact from the list
  ///
  /// [itemId]: ID of the contact to delete
  void onDeleteClick({required int? itemId}) async {
    try {
      emit(state.copyWith(loader: true));
      var response = await ChatRepository.instance
          .deleteContact(itemId: itemId, path: ApiConstant.deleteContact);

      if (response?.status == true) {
        // Reset pagination and refresh contact list
        contactCurrentPage = 1;
        await fetchContactList(isRefresh: true, isSwipe: true);
        AppUtils.showSnackBar(response?.message ?? '', SnackBarType.success);
      } else {
        AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
      }
    } catch (e) {
      if (kDebugMode) {
        print('MyListingCubit.onDeleteClick -------->> ${e.toString()}');
      }
    }
  }

  Future<List<ReportTypeModelList>> getSpamList() async {
    try {
      emit(state.copyWith(loader: true));

      var response = await MasterDataAPI.instance.getSpamList();
      if (response.status) {
        final spamList = response.responseData?.result ?? [];

        emit(state.copyWith(loader: false,));
        return spamList;
      } else {
        emit(state.copyWith(loader: false,));
        AppUtils.showFormErrorSnackBar(msg: response.message);
        return [];
      }
    } catch (e) {
      emit(state.copyWith(loader: false));
      AppUtils.showFormErrorSnackBar(msg: AppConstants.somethingWentWrong);
      return [];
    }
  }

  void updateChatUnreadCountGlobal() {
    updateChatUnreadCount?.call();
  }

  void clearAllChatHistory() {
    emit(state.copyWith(messages: []));
  }
}