part of 'account_type_change_cubit.dart';

@immutable
final class AccountTypeChangeLoadedState extends Equatable {
  final bool isLoading;
  final int? accountType;
  final int? businessDeleteCount;
  final int? activeListingCount;
  final int? totalCount;
  final List<MyListingItems>? activeListingList;
  final List<MyListingItems> selectedListing;

  const AccountTypeChangeLoadedState({
    this.isLoading = false,
    this.accountType,
    this.businessDeleteCount,
    this.activeListingCount,
    this.activeListingList,
    this.totalCount,
    this.selectedListing = const [],
  });

  @override
  List<Object?> get props => [
        isLoading,
        accountType,
        activeListingList,
        selectedListing,
        businessDeleteCount,
        activeListingCount,
        totalCount,
        identityHashCode(this)
      ];

  AccountTypeChangeLoadedState copyWith({
    bool? isLoading,
    bool? selectAll,
    int? accountType,
    int? activeListingCount,
    int? businessDeleteCount,
    int? totalCount,
    List<MyListingItems>? activeListingList,
    List<MyListingItems>? selectedListing,
  }) {
    return AccountTypeChangeLoadedState(
      isLoading: isLoading ?? this.isLoading,
      accountType: accountType ?? this.accountType,
      activeListingCount: activeListingCount ?? this.activeListingCount,
      businessDeleteCount: businessDeleteCount ?? this.businessDeleteCount,
      activeListingList: activeListingList ?? this.activeListingList,
      selectedListing: selectedListing ?? this.selectedListing,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
