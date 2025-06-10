import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/listing_statistics/cubit/listing_statistics_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11-09-2024
/// @Message : [RatingScreen]
///

/// This `RatingScreen` is 3rd tab of listing statistics screen which displays rating of the event given by client.
/// This gives list of all the rating with its user name and rating, and its date and feedback of client.
/// It also gives total count of review on the service given by reviewer.
///
/// Responsibilities:
/// - Display list of ratings on its feedback details and date of it.

class RatingScreen extends StatelessWidget {
  final ListingStatisticsLoadedState state;

  const RatingScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _mobileView();
        },
      ),
    );
  }

  ///Mobile view which contains total count of reviews and ratings list with details
  Widget _mobileView() {
    return Column(
      children: [
        _totalCount(),
        sizedBox20Height(),
        _ratingListView(),
      ],
    );
  }

  ///Total count based on data from api with list length.
  Widget _totalCount() {
    return Center(
      child: Text(
        AppConstants.totalReview.replaceFirst('{count}', '${state.statisticsRatingsItemsResult?.length ?? '0'}'),
        style: FontTypography.snackBarTitleStyle,
      ),
    );
  }

  ///Rating List view with contains name reviewer image, ratings in star, date and feedback
  Widget _ratingListView() {
    return ListView.builder(
      itemCount: state.statisticsRatingsItemsResult?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final rating = state.statisticsRatingsItemsResult?[index];
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
                    backgroundColor: Colors.white, // White background for the avatar
                    backgroundImage: LoadNetworkImageProvider.getNetworkImageProvider(url: rating?.profilePic ?? ''),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                rating?.userName ?? '',
                                style: FontTypography.statisticsTitleStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        // Rating Stars and Rating Score
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ...AppUtils.buildStarIcons(double.parse('${rating?.ratingThumbsUp ?? 0.0}')),
                                const SizedBox(width: 5),
                                Text(
                                  '${rating?.ratingThumbsUp ?? 0}',
                                  style: FontTypography.subTextBoldStyle,
                                ),
                              ],
                            ),
                            sizedBox20Width(),
                            Flexible(
                              child: Text(
                                rating?.getDateCreated ?? '',
                                style: FontTypography.dateTimeTxtStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sizedBox15Height(),
              // Description
              Text(
                rating?.ratingComment ?? '',
                style: FontTypography.enquiryCityTxtStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
