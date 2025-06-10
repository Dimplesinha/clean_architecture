import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/models/chat/chat_result_common_model.dart';
import 'package:workapp/src/domain/models/chat/report_type_list.dart';
import 'package:workapp/src/domain/models/send_message_model.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/view/app_carousel.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_screen_cubit.dart';
import 'package:workapp/src/presentation/modules/message_chat/cubit/message_chat_cubit.dart';
import 'package:workapp/src/presentation/modules/message_chat/view/message_tail.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/repo/my_listing_repo.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/expansion_tile.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/animated_expansion_tile.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/deeplink_helper.dart';
import 'package:workapp/src/utils/signalr_helper.dart';

class MessageChatScreen extends StatefulWidget {
  final int? receiverId;
  final int? senderId;
  final String? senderName;
  final int? latestMessageId;
  final int? messageListId;
  final String? initialMessageText;
  final int? itemId;
  final int? itemListId;
  final int? businessCategoryId;

  const MessageChatScreen(
      {super.key,
      this.receiverId,
      this.senderId,
      this.senderName,
      this.latestMessageId,
      this.messageListId,
      this.initialMessageText = '',
      this.itemId,
      this.itemListId,
      this.businessCategoryId});

  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> with WidgetsBindingObserver {
  final MessageChatCubit messageChatCubit = MessageChatCubit();
  final MessageCubit messageCubit = MessageCubit();
  final MyListingCubit myListingCubit = MyListingCubit(myListingRepo: MyListingRepo.instance);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  AnimatedExpansionTileController controller = AnimatedExpansionTileController();
  int currentPage = 0;
  OverlayEntry? _overlayEntry;
  final Map<int, GlobalKey> _messageKeys = {};
  final SignalRHelper signalRHelper = SignalRHelper.instance;
  final _deepLinkHelper = DeepLinkHelper();
  Timer? _typingTimer;
  String? initialMessageText;
  int? messageId;

  @override
  void initState() {
    initialMessageText = widget.initialMessageText != 'null' ? widget.initialMessageText ?? '' : '';
    _messageController.text = initialMessageText!.replaceAll(RegExp(r'<[^>]*>'), '');
    messageChatCubit.fetchChat(
        receiverId: widget.receiverId, messageListId: widget.messageListId, lastMessageId: 0, currentPage: 0);
    messageChatCubit.globalMessageList.clear();
    messageCubit.refreshState();
    super.initState();
    ScreenCubit().setScreen(ActiveScreen.chatScreen);
    _deepLinkHelper.init();
    _deepLinkHelper.onLinkReceived = (link) {
      debugPrint('Received link: $link');
    };
    initData();
    // Set the callback for receiving messages
    signalRHelper.onMessageReceived = (message) {
      if (message.messageListingId != widget.messageListId) return;
      messageChatCubit.updateIncomingMessageToList(
          message: message, messageListId: widget.messageListId, latestMessageId: message.messageId);
    };

    // Set the callback for receiving messages for typing status
    signalRHelper.typingStatus = (typingStatus) {
      messageChatCubit.messageTypingStatus(typingStatus: typingStatus);
    };

    // Set the callback for mark As Read
    signalRHelper.markMessageAsRead = (markAsRead) {
      messageChatCubit.updateMessageReadStatus();
    };

    // Set the callback for block and unblock user
    signalRHelper.blockUnBlockUserFromSignalR = (result) {
      messageChatCubit.updateBlockedStatus(result, widget.receiverId);
    };
  }

  void initData() async {
    await messageChatCubit.chatDetail(otherUserId: widget.receiverId, itemListId: widget.itemListId);
    scrollController.addListener(_scrollListener);

    var messageListId = widget.messageListId;
    if (widget.messageListId == 0) {
      messageListId = messageChatCubit.state.chatResult?.messageListId;
    }

    var user = await PreferenceHelper.instance.getUserData();
    if (messageChatCubit.state.messages?[0].senderId != user.result?.id) {
      messageChatCubit.markAsReadMessage(messageListId: messageListId, latestMessageId: widget.latestMessageId);
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50 &&
        !messageChatCubit.state.loader &&
        messageChatCubit.state.hasMoreItems) {
      messageChatCubit.fetchChat(
          receiverId: widget.receiverId,
          messageListId: widget.messageListId,
          lastMessageId: messageChatCubit.state.messages?.isNotEmpty == true
              ? messageChatCubit.state.messages!.last.messageId
              : null,
          isLoadMore: true,
          currentPage: messageChatCubit.state.currentPage);
    }
  }

  void blockFunctionality() {
    final chatDetails = messageChatCubit.globalChatDetailResult;
    final isBlockedByMe = chatDetails?.isBlockedByMe ?? false;

    void showSnackBar(String message, {bool isError = false}) {
      AppUtils.showSnackBar(message, isError ? SnackBarType.fail : SnackBarType.success);
    }

    final shouldBlock = !isBlockedByMe;

    ReusableWidgets.showConfirmationDialog(
      AppConstants.appTitleStr,
      shouldBlock ? AppConstants.confirmBlockUser : AppConstants.confirmUnblockUser,
      () {
        Navigator.of(context).pop();
        _blockOrUnblockUser(shouldBlock, showSnackBar);
      },
    );
  }

  void _blockOrUnblockUser(bool isBlock, void Function(String, {bool isError}) showSnackBar) {
    messageChatCubit.blockUnBlockUser(
      receiverId: widget.receiverId,
      isBlock: isBlock,
    );
  }

  void handleActivityTracking() {
    myListingCubit.manageActivityTracking(
      listingId: widget.itemId,
      categoryId: widget.businessCategoryId,
      activityTypeId: AppUtils.getActivityId(activityType: AppConstants.messageStr),
      deviceTypeId: AppUtils.getDeviceTypeId(),
    );
  }

  void _showMessageOptions(
      BuildContext context, ChatResultCommonModel message, bool isSender, int index, MessageChatState state) {
    final messageKey = _messageKeys[index];
    final RenderBox? messageWidget = messageKey?.currentContext?.findRenderObject() as RenderBox?;
    if (messageWidget == null) return;

    final messagePosition = messageWidget.localToGlobal(Offset.zero);
    final messageHeight = messageWidget.size.height;
    final messageWidth = messageWidget.size.width;

    _overlayEntry = OverlayEntry(
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              onTap: _removeOverlay,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.transparent),
              ),
            ),
            // Re-render the selected message above the blur
            Positioned(
              left: messagePosition.dx,
              top: messagePosition.dy,
              width: messageWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildMessageContent(message, isSender, state),
              ),
            ),
            // Options menu below the message
            Positioned(
              left: isSender ? messagePosition.dx + messageWidth - 160 : messagePosition.dx,
              top: messagePosition.dy + messageHeight - 10,
              width: 150,
              // right: messagePosition.dx,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _removeOverlay();
                          _deleteMessage(context, message, index);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(AppConstants.deleteMessageStr, style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _deleteMessage(BuildContext context, ChatResultCommonModel message, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text(AppConstants.deleteMessageStr),
        content: const Text(AppConstants.confirmDeleteChatMessage),
        actions: [
          TextButton(
            onPressed: () {
              messageChatCubit.deleteParticularMessage(
                messageId: message.messageId,
                receiverId: widget.receiverId,
                index: index,
              );
              Navigator.pop(context);
            },
            child: Text(
              AppConstants.yesStr,
              style: FontTypography.chipStyle,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppConstants.noStr,
              style: FontTypography.chipStyle,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build message content
  Widget _buildMessageContent(ChatResultCommonModel message, bool isSender, MessageChatState state) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isSender)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: LoadProfileImage(url: state.chatResult?.sender?.profilePic),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    MessageTail(
                      text: message.messageContent ?? '',
                      bubbleColor: isSender ? AppColors.primaryColor : AppColors.locationButtonBackgroundColor,
                      hasTail: true,
                      isSender: isSender,
                      textStyle: FontTypography.forgetPassStyle.copyWith(
                        color: isSender ? AppColors.whiteColor : AppColors.blackColor,
                      ),
                      messageStatus: message.messageStatusId,
                      onLinkTapped: () {
                        _removeOverlay();
                      },
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        message.sentAt != null ? AppUtils.groupMessageDateAndTime(message.sentAt ?? '') : '',
                        style: FontTypography.tabBarStyle.copyWith(color: AppColors.subTextColor),
                      ),
                    ),
                    const SizedBox(height: 21),
                  ],
                ),
              ),
              if (isSender)
                Padding(
                  padding: const EdgeInsets.only(bottom: 45.0),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: LoadProfileImage(url: state.chatResult?.currentUser?.profilePic),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _removeOverlay();
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _deepLinkHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageChatCubit, MessageChatState>(
      bloc: messageChatCubit,
      builder: (context, state) {
        if (messageCubit.state.isChatDeleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }
        return Stack(
          children: [
            Container(
              color: AppColors.primaryColor,
              child: SafeArea(
                bottom: false,
                child: Scaffold(
                  backgroundColor: AppColors.whiteColor,
                  appBar: MyAppBar(
                    elevation: 2,
                    centerTitle: true,
                    title: widget.senderName ?? state.chatResult?.sender?.userName ?? '',
                    actionList: [
                      PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) async {
                            switch (result) {
                              case AppConstants.addToContactStr:
                                var addToContact = await messageChatCubit.addToContactFromChat(
                                  otherUserId: widget.receiverId,
                                );
                                if (addToContact != null) {
                                  AppUtils.showSnackBar(addToContact.message ?? '', SnackBarType.success);
                                }
                                break;
                              case AppConstants.blockStr:
                                blockFunctionality();
                                break;
                              case AppConstants.unblockStr:
                                blockFunctionality();
                                break;
                              case AppConstants.userAsSpam:
                                showSpamReportDialog(context);
                                break;
                              case AppConstants.deleteStr:
                                ReusableWidgets.showConfirmationDialog(
                                  AppConstants.appTitleStr,
                                  AppConstants.confirmDeleteChat,
                                  () async {
                                    Navigator.pop(context);
                                    await messageChatCubit.setLoader(true);
                                    await messageCubit.deleteEntireChat(
                                        receiverId: widget.receiverId, messageListId: widget.messageListId);
                                    await messageChatCubit.setLoader(false);
                                  },
                                );
                                break;
                            }
                          },
                          itemBuilder: (context) {
                            final chatDetail = state.chatDetailResult;
                            final showAddToContact = !(chatDetail?.isAddedInContact ?? true);
                            final isBlockedByMe = chatDetail?.isBlockedByMe ?? false;
                            final isDeleted = chatDetail?.isDeleted ?? false;

                            final List<PopupMenuEntry<String>> menuItems = [];

                            // Conditionally add "Add to Contact"
                            final shouldAddToContact = showAddToContact && !isDeleted;

                            if (shouldAddToContact) {
                              menuItems.add(
                                const PopupMenuItem<String>(
                                  value: AppConstants.addToContactStr,
                                  child: Text(AppConstants.addToContactStr),
                                ),
                              );
                            }

                            // Options when chat is not deleted
                            if (!isDeleted) {
                              menuItems.addAll([
                                PopupMenuItem<String>(
                                  value: AppConstants.blockStr,
                                  child: Text(isBlockedByMe ? AppConstants.unblockStr : AppConstants.blockStr),
                                ),
                                const PopupMenuItem<String>(
                                  value: AppConstants.deleteStr,
                                  child: Text(AppConstants.clearChatStr),
                                ),
                                const PopupMenuItem<String>(
                                  value: AppConstants.userAsSpam,
                                  child: Text(AppConstants.userAsSpam),
                                ),
                              ]);
                            } else if (state.chatDetailResult?.isDeletedItemListId == true) {
                              menuItems.addAll([
                                const PopupMenuItem<String>(
                                  value: AppConstants.deleteStr,
                                  child: Text(AppConstants.clearChatStr),
                                )
                              ]);
                            } else {
                              // Options when chat is deleted
                              menuItems.addAll([
                                const PopupMenuItem<String>(
                                  value: AppConstants.deleteStr,
                                  child: Text(AppConstants.clearChatStr),
                                ),
                              ]);
                            }

                            return menuItems;
                          }),
                    ],
                  ),
                  body: Column(
                    children: [
                      sizedBox10Height(),
                      CreateExpansionTile(
                        childrenWidget: const [
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: AppCarouselView(),
                          )
                        ],
                        controller: controller,
                        isExpanded: state.isCarouselExpanded,
                        onExpansionChanged: () {
                          messageChatCubit.onTileExpansionChanged();
                        },
                      ),
                      Expanded(
                        child: (state.messages == null || state.messages?.isEmpty == true)
                            ? state.loader
                                ? const Row()
                                : const Center(child: Text(AppConstants.noMessagesFound))
                            : ListView.builder(
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                reverse: true,
                                controller: scrollController,
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: state.messages?.length,
                                itemBuilder: (context, index) {
                                  final message = state.messages?[index];
                                  var isSender = false;
                                  messageId = message?.messageId;
                                  if (state.chatResult?.currentUser != null) {
                                    isSender = message?.senderId == state.chatResult?.currentUser?.userId;
                                  } else {
                                    isSender = true;
                                  }

                                  _messageKeys[index] ??= GlobalKey();

                                  return GestureDetector(
                                    key: _messageKeys[index],
                                    onLongPress: () {
                                      _showMessageOptions(context, message, isSender, index, state);
                                    },
                                    child: _buildMessageContent(message!, isSender, state),
                                  );
                                },
                              ),
                      ),
                      if (state.chatDetailResult?.isBlockedByMe == true) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32, top: 8, left: 16, right: 16),
                          child: SizedBox(
                            child: Text(
                              AppConstants.blockedUserMessage,
                              style: FontTypography.subTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ] else if (state.chatDetailResult?.isBlockedByUser == true) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32, top: 8, left: 16, right: 16),
                          child: SizedBox(
                            child: Text(
                              AppConstants.blockedByUserMessage,
                              style: FontTypography.subTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ] else if (state.chatDetailResult?.isDeleted == true ||
                          state.chatDetailResult?.isDeletedItemListId == true) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32, top: 8, left: 16, right: 16),
                          child: SizedBox(
                            child: Text(
                              (state.chatDetailResult?.isDeleted == true)
                                  ? AppConstants.deletedUserMessage
                                  : (state.chatDetailResult?.isDeletedItemListId == true
                                      ? AppConstants.deletedListingMessage
                                      : AppConstants.deletedListingMessage),
                              style: FontTypography.subTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ] else
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              signalRHelper.typingStatusModel?.isType == true &&
                                      ((signalRHelper.typingStatusModel?.senderId == widget.receiverId) ||
                                          (signalRHelper.typingStatusModel?.itemListId == widget.itemListId))
                                  ? const Text(AppConstants.typing)
                                  : const SizedBox(),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      hintTxt: AppConstants.messageFieldHintStr,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      controller: _messageController,
                                      minLines: 1,
                                      // Start with 1 line
                                      maxLines: 5,
                                      // Grow up to 5 lines
                                      // height: 100,
                                      onChanged: (value) async {
                                        initialMessageText = value;
                                        var user = await PreferenceHelper.instance.getUserData();
                                        var typingStatusArg = TypingStatusModel()
                                          ..receiverId = widget.receiverId
                                          ..senderId = widget.itemListId != 0 ? 0 : user.result?.id
                                          ..itemListId = widget.itemListId;

                                        // If user starts typing, send the typing status immediately
                                        if (_typingTimer == null) {
                                          typingStatusArg.isType = true;
                                          signalRHelper.typingStatusInvoke(typingStatusArg);
                                        }

                                        // Reset the timer on every keystroke
                                        _typingTimer?.cancel();
                                        _typingTimer = Timer(const Duration(seconds: 2), () {
                                          // After 2 seconds of inactivity, send stop typing event
                                          typingStatusArg.isType = false;
                                          signalRHelper.typingStatusInvoke(typingStatusArg);
                                          _typingTimer = null;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BoxShape.rectangle,
                                      color: AppColors.primaryColor,
                                    ),
                                    child: IconButton(
                                      icon: ReusableWidgets.createSvg(path: AssetPath.sendIcon),
                                      onPressed: () {
                                        initialMessageText = initialMessageText?.trim();
                                        if (initialMessageText?.isNotEmpty ?? false) {
                                          var messageListId = widget.messageListId;
                                          if (_messageController.text.isNotEmpty) {
                                            if (widget.messageListId == 0) {
                                              if (state.messages?.isNotEmpty == true) {
                                                messageListId = state.chatResult?.messageListId;
                                              }
                                            }

                                            messageChatCubit
                                                .sendMessage(
                                              itemListId: widget.itemListId,
                                              receiverId: widget.receiverId,
                                              messageContent: initialMessageText,
                                              messageListId: messageListId,
                                            )
                                                .then((value) {
                                              if (widget.itemId != null) {
                                                handleActivityTracking();
                                              }

                                              SignalRHelper.instance.triggerMessageListRefresh();
                                            });

                                            _messageController.clear();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            state.loader == true ? const LoaderView() : const SizedBox.shrink()
          ],
        );
      },
    );
  }

/*  void spamFunctionality() {
    showSpamReportDialog();
  }*/


  /// Spam Report Dialog
  void showSpamReportDialog(BuildContext context) async {
    int? selectedId;
    String? reportType;
    TextEditingController commentController = TextEditingController();
    bool isReportTypeError = false;
    List<ReportTypeModelList> reasons = await messageCubit.getSpamList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(12.0),
              backgroundColor: AppColors.whiteColor,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              title: Row(
                children: [
                  Text(
                    AppConstants.spamUserAlertBoxHeading,
                    style: FontTypography.bottomSheetHeading,
                  ),
                ],
              ),
              content: Scrollbar(
                thumbVisibility: true,
                child: SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(right: 15),
                    children: [
                      Text(
                        AppConstants.whyUserSpam,
                        style: FontTypography.textFieldBlackStyle,
                      ),
                      sizedBox10Height(),
                      ...reasons.map((entry) {
                        return RadioListTile<int>(
                          title: Text(entry.reportType ?? ''),
                          value: entry.reportTypeId ?? 0,
                          activeColor: AppColors.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          groupValue: selectedId,
                          onChanged: (int? value) {
                            setState(() {
                              selectedId = value;
                              isReportTypeError = false;
                              reportType = entry.reportType;
                            });
                          },
                        );
                      }).toList(),
                      sizedBox10Height(),
                      Visibility(
                        visible: isReportTypeError,
                        child: Text(
                          AppConstants.reportTypeRequired,
                          style: FontTypography.defaultTextStyle.copyWith(color: AppColors.errorColor),
                        ),
                      ),
                      sizedBox10Height(),
                      Text(
                        AppConstants.reasonStr,
                        style: FontTypography.textFieldBlackStyle,
                      ),
                      sizedBox10Height(),
                      TextField(
                        controller: commentController,
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
                            borderSide: BorderSide(
                              color: AppColors.blackColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                          errorText: commentController.text.trim().isEmpty && reportType == 'Other'
                              ? 'Comment Required'
                              : null,
                        ),
                      ),
                      sizedBox20Height(),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        AppRouter.pop();
                      },
                      child: Text(
                        AppConstants.cancelStr,
                        style: FontTypography.defaultTextStyle.copyWith(color: AppColors.errorColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedId == null) {
                          setState(() {
                            isReportTypeError = true;
                          });
                        } else {
                          if (reportType == 'Other' && commentController.text.trim().isEmpty) {
                          } else {
                            ReusableWidgets.showLoaderDialog();
                            messageChatCubit.spamUserReport(
                                userId: widget.receiverId.toString(),
                                reportType: selectedId,
                                comment: commentController.text.trim());
                          }
                        }
                      },
                      child: Text(
                        AppConstants.submitStr,
                        style: FontTypography.defaultTextStyle.copyWith(color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
