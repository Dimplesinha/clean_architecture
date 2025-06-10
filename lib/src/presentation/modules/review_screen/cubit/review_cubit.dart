import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/review_screen/repo/review_repo.dart';
import 'package:workapp/src/utils/app_utils.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  bool hasNextPage = true;
  int currentPage = 1;
  int rattingCount = 1;

  ReviewCubit() : super(ReviewInitial());

  void init({required int listingId, required int categoryId}) async {
    emit(const ReviewLoadedState());
    await fetchRatings(categoryId: categoryId, listingId: listingId);
    await fetchReviews(categoryId: categoryId, listingId: listingId);
  }

  /// fetch rating of particular item
  Future<void> fetchRatings({required int listingId, required int categoryId}) async {
    var oldState = state as ReviewLoadedState;
    try {
      emit(oldState.copyWith(loader: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.listingId: listingId,
        ModelKeys.categoryId: categoryId,
      };
      var response = await ReviewRepo.instance.fetchRatingList(requestBody: requestBody);
      if (response.status == true && response.responseData != null) {
        emit(oldState.copyWith(loader: false, ratingListData: response.responseData?.result));
      } else {
        emit(oldState.copyWith(loader: false, ratingListData: response.responseData?.result));
      }
    } catch (e) {
      emit(oldState.copyWith(
        loader: false,
      ));
    }
  }

  Future<void> fetchReviews({bool isRefresh = false, required int listingId, required int categoryId}) async {
    var oldState = state as ReviewLoadedState;
    try {
      emit(oldState.copyWith(loader: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.listingId: listingId,
        ModelKeys.categoryId: categoryId,
        ModelKeys.pageIndex: currentPage,
        ModelKeys.pageSize: AppConstants.pageSize,
      };
      var response = await ReviewRepo.instance.fetchReviewList(requestBody: requestBody);
      if (response.status == true && response.responseData != null) {
        List<Reviews> reviews = (response.responseData?.result?.review ?? []);

        if (reviews.length == AppConstants.pageSize) {
          hasNextPage = true;
          currentPage++;
        } else {
          hasNextPage = false;
        }

        if (isRefresh == true) {
          oldState.reviews?.clear();
        }

        List<Reviews> reviewListingItems = isRefresh
            ? reviews // start fresh with new items
            : [...?oldState.reviews, ...reviews];

        emit(oldState.copyWith(loader: false, reviews: reviewListingItems, reviewList: response.responseData?.result));
      } else {
        emit(oldState.copyWith(loader: false, reviewList: response.responseData?.result));
      }
    } catch (e) {
      emit(oldState.copyWith(
        loader: false,
      ));
    }
  }

  /// add rating to particular item
  Future<void> addRatingReview(
      {required int listingId,
      required int categoryId,
      required int ratingThumbsUp,
      required String ratingComment,
      required int ratingId}) async {
    emit(const ReviewLoadedState());
    var oldState = state as ReviewLoadedState;
    try {
      var user = await PreferenceHelper.instance.getUserData();
      int? userId = user.result?.id;
      emit(oldState.copyWith(loader: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.userId: userId,
        ModelKeys.listingId: listingId,
        ModelKeys.categoryId: categoryId,
        ModelKeys.ratingThumbsUp: ratingThumbsUp,
        ModelKeys.ratingComment: ratingComment,
      };

      var response = await ReviewRepo.instance.addRatingReview(requestBody: requestBody, ratingId: ratingId);
      if (response.status == true && response.responseData != null) {
        emit(oldState.copyWith(loader: false, rating: response.responseData));

        AppRouter.pop(res: {
          ModelKeys.ratingId: response.responseData?.result ?? ratingId,
          ModelKeys.ratingThumbsUp: ratingThumbsUp,
          ModelKeys.ratingComment: ratingComment,
        });
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
        emit(oldState.copyWith(loader: false, rating: response.responseData));
        AppRouter.pop();
      }
    } catch (e) {
      emit(oldState.copyWith(
        loader: false,
      ));
    }
  }
}
