part of 'review_cubit.dart';

@immutable
sealed class ReviewState extends Equatable {
  const ReviewState();
}

final class ReviewInitial extends ReviewState {
  @override
  List<Object> get props => [];
}

final class ReviewLoadedState extends ReviewState {
  final bool loader;
  final RatingListResult? ratingListData;
  final ReviewListModel? reviewList;
  final RatingModel? rating;
  final List<Reviews>? reviews;

  const ReviewLoadedState({
    this.loader = false,
    this.ratingListData,
    this.reviewList,
    this.reviews,
    this.rating,
  });

  @override
  List<Object?> get props => [
        loader,
        ratingListData,
        reviewList,
    rating
      ];

  ReviewLoadedState copyWith({bool? loader, RatingListResult? ratingListData, ReviewListModel? reviewList, List<Reviews>? reviews,RatingModel? rating}) {
    return ReviewLoadedState(
      loader: loader ?? this.loader,
      ratingListData: ratingListData ?? this.ratingListData,
      reviewList: reviewList ?? this.reviewList,
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
    );
  }
}
