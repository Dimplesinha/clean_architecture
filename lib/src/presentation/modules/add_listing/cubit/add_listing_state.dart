part of 'add_listing_cubit.dart';

@immutable
sealed class AddListingState extends Equatable {
  const AddListingState();
}

final class AddListingInitial extends AddListingState {
  @override
  List<Object> get props => [];
}

final class AddListingLoadedState extends AddListingState {
  final List<CategoriesListResponse>? listings;
  final String? accountType;

  const AddListingLoadedState({this.listings, this.accountType});

  @override
  List<Object?> get props => [listings,accountType];

  AddListingLoadedState copyWith({
    List<CategoriesListResponse>? listings,
    String? accountType,
  }) {
    return AddListingLoadedState(
      listings: listings ?? this.listings,
      accountType: accountType ?? this.accountType,
    );
  }
}
