import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/presentation/modules/review_screen/cubit/review_cubit.dart';
import 'package:workapp/src/presentation/modules/review_screen/view/write_review_screen.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 16/09/24
/// @Message : [ReviewScreen]
///
/// The `ReviewScreen`  class provides a user interface to preview rating of all the user for specific item
/// has a write a review button displays a bottom to sheet to write review and give rating
class ReviewScreen extends StatefulWidget {
  final int itemId;
  final int categoryId;
  final String itemName;
  final bool isFromMyRatings;

  const ReviewScreen({super.key, required this.itemId, required this.categoryId, required this.itemName, required this.isFromMyRatings});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  ReviewCubit reviewCubit = ReviewCubit();
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && reviewCubit.hasNextPage) {
          reviewCubit.fetchReviews(categoryId: widget.categoryId, listingId: widget.itemId, isRefresh: false);
        }
      }
    });
    super.initState();
    reviewCubit.init(listingId: widget.itemId, categoryId: widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      bloc: reviewCubit,
      builder: (context, state) {
        if (state is ReviewLoadedState) {
          return Container(
            color: AppColors.primaryColor,
            child: SafeArea(
              bottom: false,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.whiteColor,
                appBar: const MyAppBar(
                  elevation: 3,
                  centerTitle: true,
                  title: AppConstants.reviewScreenStr,
                ),
                body: RefreshIndicator(
                  backgroundColor: AppColors.whiteColor,
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    reviewCubit.currentPage = 1;
                    await reviewCubit.fetchReviews(listingId: widget.itemId, categoryId: widget.categoryId);
                    await reviewCubit.fetchRatings(listingId: widget.itemId, categoryId: widget.categoryId);
                  },
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.itemName,
                              textAlign: TextAlign.center,
                              style: FontTypography.profileTitleHeading.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: state.ratingListData?.avgRating != null,
                              replacement: Center(
                                child: state.loader
                                    ? const SizedBox.shrink()
                                    : Center(
                                        child: Text(
                                          (state.reviews?.isNotEmpty ?? false) ? AppConstants.reviewsFoundNotUpdatedYetStr : AppConstants.noRatingsReviewsYetStr,
                                          style: FontTypography.defaultTextStyle,textAlign: TextAlign.center,
                                        ),
                                      ),
                              ),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: state.ratingListData?.avgRating != null,
                                    replacement: Center(
                                      child: Text(
                                        AppConstants.noRatingsYetStr,
                                        style: FontTypography.defaultTextStyle,
                                      ),
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          Text(
                                            state.ratingListData?.avgRating.toString() ?? '',
                                            style: FontTypography.profileTitleHeading.copyWith(fontSize: 46, fontWeight: FontWeight.w700),
                                          ),
                                          sizedBox10Height(),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [...AppUtils.buildStarIcons(state.ratingListData?.avgRating ?? 0, iconSize: 18)],
                                          ),
                                          sizedBox10Height(),
                                          Text(
                                            '${AppConstants.basedOnStr} ${state.ratingListData?.totalRatingCount ?? '0'} ${AppConstants.reviewStr}',
                                            style: FontTypography.enquiryCityTxtStyle.copyWith(fontSize: 18),
                                          ),
                                          const SizedBox(height: 19),
                                          ratingIndicator(AppConstants.excellentStr, state.ratingListData),
                                          ratingIndicator(AppConstants.goodStr, state.ratingListData),
                                          ratingIndicator(AppConstants.avgStr, state.ratingListData),
                                          ratingIndicator(AppConstants.belowAvgStr, state.ratingListData),
                                          ratingIndicator(AppConstants.poorStr, state.ratingListData),
                                          const Divider(thickness: 0.2),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: state.reviews?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final reviews = state.reviews?[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 20.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: LoadNetworkImageProvider.getNetworkImageProvider(url: reviews?.profilePic ?? ''),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            reviews?.userName ?? '',
                                                            style: FontTypography.subTextStyle.copyWith(
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // Rating Stars and Rating Score
                                                      Row(
                                                        children: [
                                                          ...AppUtils.buildStarIcons(double.tryParse(reviews?.ratingThumbsUp.toString() ?? '') ?? 0.0),
                                                          const SizedBox(width: 5),
                                                          InkWell(
                                                            onTap: () {
                                                              AppRouter.push(AppRoutes.reviewScreenRoute);
                                                            },
                                                            child: Text(
                                                              reviews?.ratingThumbsUp.toString() ?? '',
                                                              style: FontTypography.ratingNumberTxtStyle,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            reviews?.dateCreated != null ? AppUtils.currentDateTime(reviews?.dateCreated ?? '') : '',
                                                            style: FontTypography.reviewTimeTxtStyle,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            // Description
                                            Text(
                                              reviews?.ratingComment ?? '',
                                              style: FontTypography.enquiryCityTxtStyle,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      state.loader ? const LoaderView() : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget ratingIndicator(String label, RatingListResult? reviewData) {
    double totalStarsCount = reviewData?.avgRating ?? 0.0;
    int starCount = getStarCountByLabel(label, reviewData);

    double percent = totalStarsCount > 0 ? (starCount / totalStarsCount) : 0.0;
    final Color progressColor = AppUtils.getRatingColor(label);

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: FontTypography.enquiryCityTxtStyle),
          ),
          Expanded(
            child: LinearPercentIndicator(
              lineHeight: 7.0,
              percent: percent,
              backgroundColor: AppColors.progressBgColor,
              progressColor: progressColor,
              barRadius: const Radius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  /// Give count of 5 star, 4 star , 3 star, 2 star, 1 star according to label
  int getStarCountByLabel(String label, RatingListResult? reviewData) {
    switch (label) {
      case AppConstants.excellentStr:
        return reviewData?.excellent ?? 0;
      case AppConstants.goodStr:
        return reviewData?.good ?? 0;
      case AppConstants.avgStr:
        return reviewData?.average ?? 0;
      case AppConstants.belowAvgStr:
        return reviewData?.belowAverage ?? 0;
      case AppConstants.poorStr:
        return reviewData?.poor ?? 0;
      default:
        return 0;
    }
  }
}
