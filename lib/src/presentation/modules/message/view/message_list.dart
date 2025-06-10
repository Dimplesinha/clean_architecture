import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/reusable_widgets.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_screen_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/signalr_helper.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [MessageView]
///
/// The `MessageView` class provides a UI for displaying a list of messages with a search field
/// to search contacts.
///
/// Responsibilities:
/// - Displays a list of messages from different contacts
/// - Shows last messages for each conversation
/// - Displays unread message count
/// - Shows last message timestamp
///
class MessageView extends StatefulWidget {
  final ScrollController scrollController; // Controller for handling scroll behavior
  final MessageState state;

  const MessageView({
    super.key,
    required this.scrollController,
    required this.state,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  // final SignalRHelper _signalRHelper = SignalRHelper();  // Commented out SignalR helper
  int unreadCount = 0; // Counter for unread messages
  String? selectedConversationUserId; // ID of selected conversation user
  int currentPage = 0; // Current page number for pagination
  bool _isLoadingMore = false; // Flag to track if more items are being loaded

  final StreamController<bool> _streamControllerClearBtn =
      StreamController<bool>.broadcast();
  Stream<bool> get _streamClearBtn => _streamControllerClearBtn.stream;

  final SignalRHelper signalRHelper = SignalRHelper.instance;
  late MessageCubit messageCubit;

  @override
  void initState() {
    messageCubit = context.read<MessageCubit>();

    signalRHelper.connect(AppUtils.loginUserModel?.uuid ?? '', (success, result, error) {
      if (success && result != null && error == null) {
        signalRHelper.sendConnectionId?.call(result);
      }
    },);

    super.initState();

    // Set the screen when the widget is first created
    ScreenCubit().setScreen(ActiveScreen.chatListingScreen);

    initData();

    // Set the callback for receiving messages
    signalRHelper.onMessageReceivedInListingScreen = (message) {
      messageCubit.updateIncomingMessageToList(message: message);
    };

    // Set the callback for receiving messages for typing status
    signalRHelper.typingStatusInListingScreen = (typingStatus) {
      messageCubit.messageTypingStatus(typingStatus: typingStatus);
    };
  }

  void updateChatUnreadCount() {
    messageCubit.updateChatUnreadCountGlobal();
  }

  Future<void> initData() async {
    // Add scroll listener for infinite scrolling
    widget.scrollController.addListener(_scrollListener);

    // Initial fetch of messages
    await messageCubit.fetchItems();
  }

  /// Handles scroll events for infinite loading
  void _scrollListener() async {
    // Check if user has scrolled near the bottom
   /* if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      // Load more items if not already loading and more items exist
      if (!(messageCubit.state.loader ?? false) &&
          messageCubit.state.hasMoreItems == true &&
          !_isLoadingMore) {
        _isLoadingMore = true;
        // Fetch more items and update loading state
        await messageCubit.fetchItems(isLoadMore: true).then((_) {
          _isLoadingMore = false;
        });
      }
    }
*/
    widget.scrollController.addListener(() async {
      if (widget.scrollController.position.atEdge) {
        if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent &&
            messageCubit.hasNextPage) {
          _isLoadingMore = true;
          // Fetch more items and update loading state
          await messageCubit.fetchItems(isLoadMore: true).then((_) {
            _isLoadingMore = false;
          });
        }
      }
      //dashboardCubit.updateScrollPosition(verticalScrollController.offset);
    });
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
    messageCubit.clearAllChatHistory();
    ScreenCubit().setScreen(ActiveScreen.homeScreen);
  }

  Future<void> _onSearchClick() async {
    messageCubit.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MessageCubit>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search input field
          const SizedBox(height: 20),
          ReusableWidgets.searchWidget(
            onSubmit: (value) {
              _onSearchClick();
            },
            onChanged: (value) =>
                _streamControllerClearBtn.add(value.isNotEmpty),
            stream: _streamClearBtn,
            onCancelClick: () {
              _streamControllerClearBtn.add(false);
              messageCubit.searchTxtController.clear();
              _onSearchClick();
            },
            onSearchIconClick: () {
              _onSearchClick();
            },
            txtController: messageCubit.searchTxtController,
          ),
          const SizedBox(height: 20),
          // Empty state when no messages are found
          if (state.messages.isEmpty)
            // Messages list
            const Center(child: Text(AppConstants.noMessagesFound))
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(state.messages.length, (index) {
                final message = state.messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      messageCubit.updateUnreadCount(messageListId: message.messageListId);
                      // Navigate to chat screen with selected conversation
                      AppRouter.push(AppRoutes.messageChatScreenRoute, args: {
                        ModelKeys.receiverId: message.userId,
                        ModelKeys.senderName: message.userName,
                        ModelKeys.lastMessageId: message.latestMessage?.messageId,
                        ModelKeys.messageListId: message.messageListId,
                        ModelKeys.itemListId: message.itemListId
                      })?.then((value) {
                        ScreenCubit().setScreen(ActiveScreen.chatListingScreen);
                        messageCubit.fetchItems();
                        updateChatUnreadCount();
                        messageCubit.calculateTotalUnreadAndNotify();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          // User profile picture
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child:
                                  LoadProfileImage(url: message.profilePic),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // User name and last message
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.userName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FontTypography.subTextBoldStyle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  // state.typingStatusModel?.receiverId == message.latestMessage?.receiverId && state.typingStatusModel?.isType == true ? 'Typing...' :
                                  message.latestMessage?.messageContent?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FontTypography.snackBarButtonStyle
                                      .copyWith(
                                    color: AppColors.subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Message timestamp and unread count
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message.latestMessage?.sentAt != null
                                    ? AppUtils.groupMessageDateAndTime1(
                                        message.latestMessage?.sentAt ?? '')
                                    : '',
                                style: (message.unreadCount ?? 0) > 0 ?
                                FontTypography.listingTimeStyleGreen : FontTypography.listingTimeStyle,
                              ),
                              const SizedBox(height: 6),
                              (message.unreadCount ?? 0) > 0
                                  ? CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                AppColors.greenColor,
                                child: Center(
                                  child: Text(
                                    '${message.unreadCount}',
                                    style: FontTypography
                                        .tabBarStyle
                                        .copyWith(
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              )
                                  : const SizedBox()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
