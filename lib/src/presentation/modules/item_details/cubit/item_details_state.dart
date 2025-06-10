part of 'item_details_cubit.dart';

@immutable
sealed class ItemDetailsState extends Equatable {
  const ItemDetailsState();
}

final class ItemDetailsInitial extends ItemDetailsState {
  @override
  List<Object?> get props => [];
}

final class ItemDetailsLoadedState extends ItemDetailsState {
  final bool isLoading;
  final bool isLiked;
  final bool isBookMark;
  final bool isFavClick;
  final int currentIndex;
  final int selectedTabIndex;
  final List<MyListingModel>? listings;
  final List<MyListingItems>? listingItems;
  final List<BusinessImagesModel>? imageItems;
  final List<ReportTypeModelList>? spamList;
  DynamicListingDetailModel? getDetails;

  final List<MyListingItems>? updatedListingItems;

  ItemDetailsLoadedState({
    this.isLoading = false,
    this.isLiked = false,
    this.isBookMark = false,
    this.isFavClick = false,
    this.currentIndex = 0,
    this.selectedTabIndex = 0,
    this.listings,
    this.listingItems,
    this.imageItems,
    this.getDetails,
    this.spamList,
    this.updatedListingItems,
  });

  @override
  List<Object?> get props => [
        isLoading,
        currentIndex,
        selectedTabIndex,
        listings,
        isLiked,
        isBookMark,
        listingItems,
        isFavClick,
        imageItems,
        getDetails,
    spamList,
        updatedListingItems,
      ];

  ItemDetailsLoadedState copyWith({
    bool? isLoading,
    bool? isLiked,
    bool? isBookMark,
    bool? isFavClick,
    int? currentIndex,
    int? selectedTabIndex,
    List<MyListingModel>? listings,
    List<ReportTypeModelList>? spamList,
    List<MyListingItems>? listingItems,
    List<BusinessImagesModel>? imageItems,
    DynamicListingDetailModel? getDetails,
    List<MyListingItems>? updatedListingItems,
  }) {
    return ItemDetailsLoadedState(
      isLoading: isLoading ?? this.isLoading,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      listings: listings ?? this.listings,
      listingItems: listingItems ?? this.listingItems,
      isLiked: isLiked ?? this.isLiked,
      isBookMark: isBookMark ?? this.isBookMark,
      isFavClick: isFavClick ?? this.isFavClick,
      imageItems: imageItems ?? this.imageItems,
      getDetails: getDetails ?? this.getDetails,
      spamList: spamList ?? this.spamList,
      updatedListingItems: updatedListingItems ?? this.updatedListingItems,
    );
  }
}

class ItemDetailsError extends ItemDetailsState {
  final String message;

  const ItemDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
