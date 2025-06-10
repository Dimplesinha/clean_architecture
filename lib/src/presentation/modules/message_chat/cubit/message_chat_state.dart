part of 'message_chat_cubit.dart';

// Represents the state of the chat functionality using the Equatable package for value comparison
final class MessageChatState extends Equatable {

  final ChatData? chatResult;

  // List of chat messages
  final List<ChatResultCommonModel>? messages;

  // Indicates if a loading operation is in progress
  final bool loader;

  // Controls the expansion state of the message carousel
  final bool isCarouselExpanded;

  // Stores the message marked as read
  final ChatResultCommonModel? markAsReadMessage;

  // Stores block/unblock operation result
  final BlockUnBlockModel? blockUnBlockModel;

  // Stores add to contact operation result
  final AddToContactModel? addToContactModel;

  // Stores detailed information about a specific message
  final MessageInfoResult? messageInfoResult;

  // Unique identifier for the chat
  final int? chatId;

  /// The current page number for pagination of messages
  final int currentPage;

  /// Indicates whether there are more items to load for pagination
  final bool hasMoreItems;

  // Stores the current typing status in the chat
  final TypingStatusModel? typingStatusModel;

  // Stores the chat detail result
  final ChatDetailResult? chatDetailResult;

  // Constructor with default values for all properties
  const MessageChatState({
    this.loader = false, // Loading state defaults to false
    this.messages,      // Message list can be null initially
    this.chatResult,
    this.isCarouselExpanded = true, // Carousel defaults to expanded
    this.markAsReadMessage,         // Mark as read message can be null
    this.blockUnBlockModel,         // Block/unblock result can be null
    this.addToContactModel,         // Add to contact result can be null
    this.messageInfoResult,         // Message info can be null
    this.chatId,                    // Chat ID can be null
    this.currentPage = 0,          // Pagination starts at page 0
    this.hasMoreItems = true,      // Assumes more items available initially
    this.typingStatusModel,        // Typing status can be null
    this.chatDetailResult,        // Chat detail result can be null
  });

  /// Creates a new instance with updated values while maintaining immutability
  /// Uses null-coalescing to retain existing values if new ones aren't provided
  MessageChatState copyWith({
    bool? loader,
    List<ChatResultCommonModel>? messages,
    ChatData? chatResult,
    bool? isCarouselExpanded,
    ChatResultCommonModel? markAsReadMessage,
    BlockUnBlockModel? blockUnBlockModel,
    AddToContactModel? addToContactModel,
    MessageInfoResult? messageInfoResult,
    int? chatId,
    int? currentPage,
    bool? hasMoreItems,
    TypingStatusModel? typingStatusModel,
    ChatDetailResult? chatDetailResult
  }) {
    return MessageChatState(
      messages: messages ?? this.messages,
      chatResult: chatResult ?? this.chatResult,
      loader: loader ?? this.loader,
      isCarouselExpanded: isCarouselExpanded ?? this.isCarouselExpanded,
      markAsReadMessage: markAsReadMessage ?? this.markAsReadMessage,
      blockUnBlockModel: blockUnBlockModel ?? this.blockUnBlockModel,
      addToContactModel: addToContactModel ?? this.addToContactModel,
      messageInfoResult: messageInfoResult ?? this.messageInfoResult,
      chatId: chatId ?? this.chatId,
      currentPage: currentPage ?? this.currentPage,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
      typingStatusModel: typingStatusModel ?? this.typingStatusModel,
      chatDetailResult: chatDetailResult ?? this.chatDetailResult,
    );
  }

  /// Defines the properties used for equality comparison
  /// Required by Equatable to determine if two states are identical
  @override
  List<Object?> get props => [
    loader,
    messages,
    chatResult,
    isCarouselExpanded,
    markAsReadMessage,
    blockUnBlockModel,
    addToContactModel,
    chatId,
    currentPage,
    hasMoreItems,
    typingStatusModel,
    chatDetailResult,
  ];
}