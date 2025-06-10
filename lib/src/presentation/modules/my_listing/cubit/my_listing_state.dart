part of 'my_listing_cubit.dart';

sealed class MyListingState extends Equatable {
  const MyListingState();
}

final class MyListingInitial extends MyListingState {
  @override
  List<Object> get props => [];
}

final class MyListingLoadedState extends MyListingState {
  final List<String>? listings;
  final List<MyListingModel>? myListing;
  final List<MyListingModel>? myBookmarkListing;
  final List<MyListingItems>? myBookmarkListingItem;
  final List<MyListingItems>? myListingItem;
  final List<InsightItems>? insightItems;
  final InsightCountResult? insightCountResult;
  final int? selectedIndex;
  final bool loader;
  final bool isBookMarked;
  final bool isBookMarkClicked;
  final bool isSelfLike;
  final bool isRated;
  final bool isSelfLikeClicked;
  final int? itemCount;
  final int? userId;
  final List<RatingResult>? myRatingData;
  final List<RatingItems>? myRatingItem;
  final int? selectedRatingType;
  String? ratingsSearchText;
  String? bookmarkSearchText;

  MyListingLoadedState({
    this.listings,
    this.selectedIndex = 0,
    this.myListingItem,
    this.myListing,
    this.myBookmarkListing,
    this.myBookmarkListingItem,
    this.insightItems,
    this.insightCountResult,
    this.itemCount,
    this.userId,
    this.loader = false,
    this.isBookMarked = false,
    this.isSelfLike = false,
    this.isRated = false,
    this.isBookMarkClicked = false,
    this.isSelfLikeClicked = false,
    this.myRatingData,
    this.myRatingItem,
    this.selectedRatingType = 1,
    this.ratingsSearchText = '',
    this.bookmarkSearchText = '',
  });

  @override
  List<Object?> get props => [
        listings,
        selectedIndex,
        myListingItem,
        isBookMarkClicked,
        isBookMarked,
        insightItems,
        insightCountResult,
        isSelfLikeClicked,
        isSelfLike,
        loader,
        myListing,
        myBookmarkListingItem,
        myBookmarkListing,
        itemCount,
        userId,
        myRatingItem,
        myRatingData,
        selectedRatingType,
        ratingsSearchText,
        bookmarkSearchText,
        isRated,
        identityHashCode(this),
      ];

  MyListingLoadedState copyWith({
    List<String>? listings,
    int? selectedIndex,
    List<InsightItems>? insightItems,
    InsightCountResult? insightCountResult,
    List<MyListingModel>? myListing,
    List<RatingResult>? myRatingData,
    List<MyListingModel>? myBookmarkListing,
    List<MyListingItems>? myListingItem,
    List<RatingItems>? myRatingItem,
    List<MyListingItems>? myBookmarkListingItem,
    bool? loader,
    bool? isRated,
    int? selectedRatingType,
    bool? isBookMarked,
    bool? isBookMarkClicked,
    bool? isSelfLike,
    bool? isSelfLikeClicked,
    int? itemCount,
    int? userId,
    String? ratingsSearchText,
    String? bookmarkSearchText,
  }) {
    return MyListingLoadedState(
      listings: listings ?? this.listings,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      myListing: myListing ?? this.myListing,
      myListingItem: myListingItem ?? this.myListingItem,
      loader: loader ?? this.loader,
      isBookMarked: isBookMarked ?? this.isBookMarked,
      isBookMarkClicked: isBookMarkClicked ?? this.isBookMarkClicked,
      userId: userId ?? this.userId,
      myRatingData: myRatingData ?? this.myRatingData,
      myRatingItem: myRatingItem ?? this.myRatingItem,
      itemCount: itemCount ?? this.itemCount,
      myBookmarkListing: myBookmarkListing ?? this.myBookmarkListing,
      myBookmarkListingItem: myBookmarkListingItem ?? this.myBookmarkListingItem,
      isSelfLike: isSelfLike ?? this.isSelfLike,
      isSelfLikeClicked: isSelfLikeClicked ?? this.isSelfLikeClicked,
      selectedRatingType: selectedRatingType ?? this.selectedRatingType,
      ratingsSearchText: ratingsSearchText ?? this.ratingsSearchText,
      bookmarkSearchText: bookmarkSearchText ?? this.bookmarkSearchText,
      insightItems: insightItems ?? this.insightItems,
      isRated: isRated ?? this.isRated,
      insightCountResult: insightCountResult ?? this.insightCountResult,
    );
  }
}
