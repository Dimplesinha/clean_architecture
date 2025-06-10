part of 'message_cubit.dart';

/// Represents the state of the message feature in the application.
///
/// This class holds the data and status related to message operations,
/// such as the list of messages, loading state, and pagination details.
/// It extends [Equatable] to enable value comparison for state changes.
///
final class MessageState extends Equatable {
  /// The list of chat conversation items.
  final List<ChatListResult> messages;

  /// The currently selected tab index (e.g., for tabbed views).
  final int? selectedIndex;

  /// Indicates whether data is currently being loaded.
  final bool? loader;
  final List<Contact>? myListing;
  final List<Contact>? myListingItem;

  /// The current page number for pagination.
  final int? currentPage;

  /// Indicates whether there are more items to load for pagination.
  final bool? hasMoreItems;

  /// The current page number for pagination.
  final int unreadCount;

  /// Indicates whether the chat is deleted.
  final bool isChatDeleted;

  /// Stores the current typing status in the chat
  final TypingStatusModel? typingStatusModel;

  /// Creates a new instance of [MessageState] with default values.
  ///
  /// [message]: The list of chat conversations, defaults to an empty list.
  /// [selectedIndex]: The selected tab index, defaults to 0.
  /// [loader]: Loading state, defaults to null (not loading).
  /// [currentPage]: Current page number, defaults to 1.
  /// [hasMoreItems]: Whether more items are available, defaults to true.

  MessageState({
    this.isChatDeleted = false,
    this.messages = const [],
    this.selectedIndex = 0,
    this.loader,
    this.currentPage = 1,
    this.hasMoreItems = true,
    this.unreadCount = 0,
    this.myListing,
    this.myListingItem,
    this.typingStatusModel,
  });

  /// Creates a copy of the current state with updated values.
  ///
  /// Returns a new [MessageState] instance with the provided values,
  /// falling back to the current state's values if parameters are null.
  ///
  /// [message]: Updated list of chat conversations.
  /// [selectedIndex]: Updated selected tab index.
  /// [loader]: Updated loading state.
  /// [currentPage]: Updated page number.
  /// [hasMoreItems]: Updated flag for more items availability.
  MessageState copyWith({
    List<ChatListResult>? messages,
    int? selectedIndex,
    bool? loader,
    int? currentPage,
    bool? hasMoreItems,
    int? unreadCount,
    bool? isChatDeleted,
    List<Contact>? myListing,
    List<Contact>? myListingItem,
    TypingStatusModel? typingStatusModel,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      loader: loader ?? this.loader,
      currentPage: currentPage ?? this.currentPage,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
      unreadCount: unreadCount ?? this.unreadCount,
      isChatDeleted: isChatDeleted ?? this.isChatDeleted,
      myListing: myListing ?? this.myListing,
      myListingItem: myListingItem ?? this.myListingItem,
      typingStatusModel: typingStatusModel ?? this.typingStatusModel,
    );
  }

  /// Defines the properties used for equality comparison.
  ///
  /// These properties are used by [Equatable] to determine if two
  /// [MessageState] instances are equal, triggering UI updates when changed.
  @override
  List<Object?> get props => [
        messages,
        selectedIndex,
        loader,
        currentPage,
        hasMoreItems,
        unreadCount,
        isChatDeleted,
        myListing,
        myListingItem,
    typingStatusModel,
      ];
}
