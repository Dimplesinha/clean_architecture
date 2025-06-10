part of 'new_message_cubit.dart';

@immutable
sealed class NewMessageState extends Equatable {
  const NewMessageState();
}

final class NewMessageInitial extends NewMessageState {
  @override
  List<Object> get props => [];
}

final class NewMessageLoadedState extends NewMessageState {
  final List<ContactInfo>? contactInfo;
  int? selectedIndex = 0;
  final int? lastIndex;
  final bool? loader;
  final String? inviteBy;
  final List<Contact>? myListing;
  final List<Contact>? myListingItem;

  NewMessageLoadedState({
    this.contactInfo,
    this.selectedIndex = 0,
    this.loader,
    this.inviteBy = AppConstants.emailStr,
    this.lastIndex,
    this.myListing,
    this.myListingItem,
  });

  @override
  List<Object?> get props => [
        contactInfo,
        selectedIndex,
        loader,
        inviteBy,
        lastIndex,
        myListing,
        myListingItem,
      ];

  NewMessageLoadedState copyWith({
    List<ContactInfo>? contactInfo,
    int selectedIndex = 0,
    bool? loader,
    List<int>? selectedContacts,
    List<int>? selectedGroups,
    int? lastIndex,
    String? inviteBy,
    List<Contact>? myListing,
    List<Contact>? myListingItem,
  }) {
    return NewMessageLoadedState(
      contactInfo: contactInfo ?? this.contactInfo,
      selectedIndex: selectedIndex,
      lastIndex: lastIndex ?? this.lastIndex,
      inviteBy: inviteBy ?? this.inviteBy,
      loader: loader ?? this.loader,
      myListing: myListing ?? this.myListing,
      myListingItem: myListingItem ?? this.myListingItem,
    );
  }
}
