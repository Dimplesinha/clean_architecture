part of 'my_contact_user_listing_cubit.dart';

sealed class MyContactUserListingState extends Equatable {
  const MyContactUserListingState();
}

final class MyContactUserListingInitial extends MyContactUserListingState {
  @override
  List<Object> get props => [];
}

final class MyContactUserListingLoadedState extends MyContactUserListingState {
  final List<MyListingModel>? contactUserListing;
  final List<MyListingItems>? contactUserListingItem;
  final int? selectedIndex;
  final bool loader;
  final List<MyListingModel>? contactUserPastListing;
  final List<MyListingItems>? contactUserPastListingItem;

  MyContactUserListingLoadedState({
    this.selectedIndex = 0,
    this.contactUserListingItem,
    this.contactUserListing,
    this.loader = false,
    this.contactUserPastListing,
    this.contactUserPastListingItem,
  });

  @override
  List<Object?> get props => [
        selectedIndex,
        contactUserListingItem,
        loader,
        contactUserListing,
        contactUserPastListing,
        contactUserPastListingItem,
      ];

  MyContactUserListingLoadedState copyWith({
    int? selectedIndex,
    List<MyListingModel>? contactUserListing,
    List<MyListingItems>? contactUserListingItem,
    bool? loader,
    List<MyListingModel>? contactUserPastListing,
    List<MyListingItems>? contactUserPastListingItem,
  }) {
    return MyContactUserListingLoadedState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      contactUserListing: contactUserListing ?? this.contactUserListing,
      contactUserListingItem: contactUserListingItem ?? this.contactUserListingItem,
      loader: loader ?? this.loader,
      contactUserPastListing: contactUserPastListing ?? this.contactUserPastListing,
      contactUserPastListingItem: contactUserPastListingItem ?? this.contactUserPastListingItem,
    );
  }
}
