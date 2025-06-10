import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/listing_statistics/cubit/listing_statistics_cubit.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 10-09-2024
/// @Message : [InsightScreen]

/// This `InsightScreen` view is for all insights that is added on Listing statistics screen
/// This displays all the details related to enquire basic details of calls and counts, mail and its count, message
/// and its count total views of your profile and its count etc.
///
/// Responsibilities:
/// - Display all details related to your account stats and keeps on updating.
/// - This also contains last refresh for updated all details.
/// - Total Profile view count and all details related to your account.
class InsightScreen extends StatelessWidget {
  final ListingStatisticsLoadedState state;
  final Function() onBoostClick;
  final bool? isActiveListing;

  const InsightScreen({super.key, required this.state, required this.onBoostClick, this.isActiveListing});

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

  /// Mobile View with all the basic details, all advance details related to profile and
  Widget _mobileView() {
    return Column(
      children: [
        _enquiriesBasicDetails(),
        sizedBox20Height(),
        _enquiriesAdvanceDetails(),
        sizedBox20Height(),
        _enquiriesAccountDetails()
      ],
    );
  }

  ///This has all basic details related to call, message, mails,uniqueVisitors, and total view and its count and
  ///there icons with custom container.
  Widget _enquiriesBasicDetails() {
    return _detailContainer(
      containerChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowWithDetails(
            assetPath: AssetPath.callIcon,
            title: AppConstants.callsStr,
            count: state.statisticsInsightResult?.calls ?? '-',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.mailIcon,
            title: AppConstants.emailStr,
            count: state.statisticsInsightResult?.email ?? '-',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.messageOutlineIcon,
            title: AppConstants.messagesStr,
            count: state.statisticsInsightResult?.message ?? '-',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.uniqueVisitorsIcon,
            title: AppConstants.uniqueVisitorsStr,
            count: state.statisticsInsightResult?.uniqueVisitor ?? '-',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.eyeIcon,
            title: AppConstants.totalViewStr,
            count: state.statisticsInsightResult?.viewCount ?? '-',
          ),
        ],
      ),
    );
  }

  /// This has all advance enquiry details related to how many time you clicked on website,date of account created,
  /// last account refreshed, total time of activity, and avg account view and all the counts related to it.
  Widget _enquiriesAdvanceDetails() {
    return _detailContainer(
      containerChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowWithDetails(
            assetPath: AssetPath.websiteEarthIcon,
            title: AppConstants.clickWebsiteStr,
            count: state.statisticsInsightResult?.websiteCount ?? '-',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.calendarIcon,
            title: AppConstants.createdDateStr,
            count: state.statisticsInsightResult?.getDateCreated ?? '',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.clockIcon,
            title: AppConstants.totalTimeActiveStr,
            count: state.statisticsInsightResult?.getTotalActiveTime ?? '-',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.eyeIcon,
            title: AppConstants.avgViewsStr,
            count: state.statisticsInsightResult?.avgViewsPerMonth != null
                ? '${state.statisticsInsightResult?.avgViewsPerMonth} ${AppConstants.viewsStr}'
                : '-',
          ),
          sizedBox20Height(),
          _rowForLastRefresh(
            assetPath: AssetPath.lastRefreshIcon,
            title: AppConstants.lastRefreshStr,
            date: state.statisticsInsightResult?.getLastRefreshDateTime ?? '',
          ),
        ],
      ),
    );
  }

  ///This has account related details where it gives count of total likes, total book mark and total time shared of
  ///profile for enquiry.
  Widget _enquiriesAccountDetails() {
    return _detailContainer(
      containerChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowWithDetails(
            assetPath: AssetPath.likeIcon,
            title: AppConstants.totalLikesStr,
            count: state.statisticsInsightResult?.totalLikeCount ?? '-',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.bookmarkIcon,
            title: AppConstants.bookMarkNowStr,
            count: state.statisticsInsightResult?.totalBookMark ?? '-',
          ),
          sizedBox20Height(),
          _rowWithDetails(
            assetPath: AssetPath.lastRefreshIcon,
            title: AppConstants.totalTimeSharedStr,
            count: state.statisticsInsightResult?.totalTimeShared ?? '-',
          ),
        ],
      ),
    );
  }

  ///Custom container with grey background color and its child for displaying details view.
  Widget _detailContainer({required Widget containerChild}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: AppColors.locationButtonBackgroundColor),
      child: containerChild,
    );
  }

  /// custom row widget for icons, title and counts.
  Widget _rowWithDetails({required String assetPath, required String title, required String count}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 7,
          child: Row(
            children: [
              ReusableWidgets.createSvg(path: assetPath, color: AppColors.blackColor, size: 16),
              sizedBox20Width(),
              Expanded(
                child: Text(
                  title,
                  style: FontTypography.insightTextBoldStyle,
                ),
              )
            ],
          ),
        ),
        Text(
          count,
          style: FontTypography.insightTextBoldStyle,
          maxLines: 1,
          textAlign: TextAlign.end,
        )
      ],
    );
  }

  Widget _rowForLastRefresh({required String assetPath, required String title, required String date}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableWidgets.createSvg(path: assetPath, size: 16),
              sizedBox20Width(),
              Expanded(child: Text(title, style: FontTypography.insightTextBoldStyle))
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(date, style: FontTypography.insightTextBoldStyle),
            const SizedBox(height: 4),
            Visibility(
              visible: isActiveListing ?? false,
              child: InkWell(
                onTap: () => onBoostClick.call(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        blurRadius: 9,
                        color: AppColors.dropShadowColor.withOpacity(0.1),
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.0),
                    child: Text(
                      AppConstants.boostStr.toUpperCase(),
                      style: FontTypography.snackBarButtonStyle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
