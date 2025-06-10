import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/enquiry_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/listing_statistics/cubit/listing_statistics_cubit.dart';
import 'package:workapp/src/presentation/modules/listing_statistics/view/enquiries_screen.dart';
import 'package:workapp/src/presentation/modules/listing_statistics/view/insight_screen.dart';
import 'package:workapp/src/presentation/modules/listing_statistics/view/rating_screen.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 10-09-2024
/// @Message : [ListingStatisticsView]

///Listing Statistics screen for insight, enquiries and ratings screen
///this view has 3 tab view there u can view different screens when clicking on 3 tab option
///Insight screen has all account related details and counts.
class ListingStatisticsView extends StatefulWidget {
  final int? listingId;
  final int? categoryId;
  final bool? isActiveListing;
  final bool? isItemBoosted;

  const ListingStatisticsView({
    super.key,
    required this.listingId,
    required this.categoryId,
    this.isActiveListing,
    this.isItemBoosted,
  });

  @override
  State<ListingStatisticsView> createState() => _ListingStatisticsViewState();
}

class _ListingStatisticsViewState extends State<ListingStatisticsView> {
  ///listing statistics cubit
  ListingStatisticsCubit listingStatisticsCubit = ListingStatisticsCubit();
  final scrollController = ScrollController();

  List<StatisticsEnquiryItem> enquiryData = [];

  ///init method for calling init state of cubit and other methods to load UI related functions.
  @override
  void initState() {
    listingStatisticsCubit.init(selectedListingId: widget.listingId, selectedCategoryId: widget.categoryId);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            listingStatisticsCubit.hasInsightRatingsNextPage) {
          if (listingStatisticsCubit.state.selectedIndex == 3) {
          listingStatisticsCubit.fetchInsightRatingPaginated();
          }
        } else if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            listingStatisticsCubit.hasInsightEnquiriesNextPage) {
          if (listingStatisticsCubit.state.selectedIndex == 2) {
            listingStatisticsCubit.fetchEnquiry();
          }
        }
      }
    });
    super.initState();
  }

  ///Scroll View with Layout builder for mobile and tab view and cubit loaded state
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<ListingStatisticsCubit, ListingStatisticsLoadedState>(
        bloc: listingStatisticsCubit,
        builder: (context, state) {
          return SafeArea(
            bottom: false,
            child: Scaffold(
              appBar: MyAppBar(
                title: AppConstants.listingStatisticsStr,
                backBtn: true,
                centerTitle: true,
                requirePop: false,
                automaticallyImplyLeading: false,
                shadowColor: AppColors.dropShadowColor.withOpacity(0.3),
                backBtnCallback: (){
                  AppRouter.pop(res: listingStatisticsCubit.isBoosted);
                },
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  listingStatisticsCubit.init(
                    selectedListingId: widget.listingId,
                    selectedCategoryId: widget.categoryId,
                    isRefresh: true,
                  );
                },
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      physics: const ClampingScrollPhysics(),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _mobileView(state);
                        },
                      ),
                    ),
                    state.loader ? const LoaderView() : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ///Mobile view for name and 3 tabs which is static view in all 3 tabs and other content visibility is set on index
  Widget _mobileView(ListingStatisticsLoadedState state) {
    enquiryData = state.statisticsEnquiryItem ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _listingStatisticsOptionRow(state),
        sizedBox20Height(),
        _nameWidget(title: state.statisticsInsightResult?.listingName ?? ''),
        sizedBox20Height(),
        Visibility(
          visible: state.selectedIndex == 1,
          child: InsightScreen(
            state: state,
            isActiveListing: widget.isActiveListing,
            onBoostClick: () async {
              await listingStatisticsCubit.toggleBoost(
                categoryId: listingStatisticsCubit.categoryId,
                itemId: listingStatisticsCubit.listingId,
              );
              listingStatisticsCubit.isBoosted = true;
            },
          ),
        ),
        Visibility(visible: state.selectedIndex == 2, child: EnquiriesScreen(enquiryData: enquiryData,itemId:widget.listingId??0)),
        Visibility(visible: state.selectedIndex == 3, child: RatingScreen(state: state)),
        sizedBox20Height(),
      ],
    );
  }

  /// Listing Statistics row with 3 tab option and name with index.
  Widget _listingStatisticsOptionRow(ListingStatisticsLoadedState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _containerOption(
          state,
          assetPath: AssetPath.insightIcon,
          title: AppConstants.insightStr,
          onTap: () => listingStatisticsCubit.selectButton(1),
          iconColor: state.selectedIndex == 1 ? AppColors.primaryColor : AppColors.locationButtonBackgroundColor,
          svgColor: state.selectedIndex == 1 ? AppColors.whiteColor : AppColors.jetBlackColor,
          textColor: state.selectedIndex == 1 ? AppColors.whiteColor : AppColors.jetBlackColor,
        ),
        _containerOption(
          state,
          assetPath: AssetPath.enquiriesIcon,
          title: AppConstants.enquiriesStr,
          onTap: () => listingStatisticsCubit.selectButton(2),
          iconColor: state.selectedIndex == 2 ? AppColors.primaryColor : AppColors.locationButtonBackgroundColor,
          svgColor: state.selectedIndex == 2 ? AppColors.whiteColor : AppColors.jetBlackColor,
          textColor: state.selectedIndex == 2 ? AppColors.whiteColor : AppColors.jetBlackColor,
        ),
        _containerOption(
          state,
          assetPath: AssetPath.ratingIcon,
          title: AppConstants.ratingStr,
          onTap: () => listingStatisticsCubit.selectButton(3),
          iconColor: state.selectedIndex == 3 ? AppColors.primaryColor : AppColors.locationButtonBackgroundColor,
          svgColor: state.selectedIndex == 3 ? AppColors.whiteColor : AppColors.jetBlackColor,
          textColor: state.selectedIndex == 3 ? AppColors.whiteColor : AppColors.jetBlackColor,
        ),
      ],
    );
  }

  ///Name widget for details of author.
  Widget _nameWidget({required String title}) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: FontTypography.changeEmailHeadingStyle,
            textAlign: TextAlign.center,
          ),
          sizedBox5Height(),
          Text(
            'By ${AppUtils.loginUserModel?.firstName} ${AppUtils.loginUserModel?.lastName}',
            style: FontTypography.listingStatTxtStyle,
          )
        ],
      ),
    );
  }

  ///Custom container option for tab view with icons, labels and color change with index.
  Widget _containerOption(
    ListingStatisticsLoadedState state, {
    required String assetPath,
    required String title,
    required Function() onTap,
    required Color iconColor,
    required Color svgColor,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30.0,
        decoration: BoxDecoration(
          color: iconColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            SvgPicture.asset(
              assetPath,
              colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
            ),
            sizedBox10Width(),
            Text(
              title,
              style: FontTypography.listingStatTxtStyle.copyWith(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
