part of 'profile_listing_cubit.dart';

sealed class ProfileListingState extends Equatable {
  const ProfileListingState();
}

final class ProfileListingInitial extends ProfileListingState {
  @override
  List<Object> get props => [];
}

class ProfileListingLoaded extends ProfileListingState {
  final bool? loader;
  final List<ListingData>? listings;

  const ProfileListingLoaded({this.loader, this.listings});
  ProfileListingLoaded copyWith({
    bool? loader,
    List<ListingData>? listings,
  }) {
    return ProfileListingLoaded(
      loader: loader ?? this.loader,
      listings: listings ?? this.listings,
    );
  }

  @override
  List<Object?> get props => [loader,listings];
}

class ListingError extends ProfileListingState {
  final String message;

  const ListingError(this.message);

  @override
  List<Object?> get props => [message];
}