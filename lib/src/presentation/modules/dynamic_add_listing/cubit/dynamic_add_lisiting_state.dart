part of 'dynamic_add_lisiting_cubit.dart';




@immutable
sealed class DynamicAddListingState extends Equatable {
  const DynamicAddListingState();
}

final class DynamicAddListingInitial extends DynamicAddListingState {
  @override
  List<Object> get props => [];
}

final class DynamicAddListingLoadedState extends DynamicAddListingState {
  final List<CategoriesListResponse>? listings;
  final List<IconDataModel>? iconData;
  final String? accountType;
  final bool isLoading;

  const DynamicAddListingLoadedState({this.listings, this.accountType,this.iconData,this.isLoading=false });

  @override
  List<Object?> get props => [listings,accountType,iconData,isLoading];

  DynamicAddListingLoadedState copyWith({
    List<CategoriesListResponse>? listings,
    List<IconDataModel>? iconData,
    String? accountType,
    bool? isLoading,
  }) {
    return DynamicAddListingLoadedState(
      listings: listings ?? this.listings,
      accountType: accountType ?? this.accountType,
      iconData: iconData ?? this.iconData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
