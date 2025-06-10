import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/cubit/app_carousel_cubit.dart';
import 'package:workapp/src/presentation/modules/app_carousel/repo/app_carousel_repo.dart';
import 'package:workapp/src/presentation/modules/app_carousel/view/app_carousel.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/repo/my_listing_repo.dart';
import 'package:workapp/src/presentation/modules/my_listing/view/my_listing_bookmark.dart';
import 'package:workapp/src/presentation/modules/my_listing/view/my_listing_filter.dart';
import 'package:workapp/src/presentation/modules/my_listing/view/my_listing_insights.dart';
import 'package:workapp/src/presentation/modules/my_listing/view/my_listing_user_rating.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/style/style.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/09/24
/// @Message : [MyListing]
///
/// The `MyListing`  class provides a user interface for performing my listing consist of tab bar view and all item view
///with tab bar of listing insights, bookmark,
class MyListing extends StatefulWidget {
  const MyListing({super.key});

  @override
  State<MyListing> createState() => _MyListingState();
}

class _MyListingState extends State<MyListing> with SingleTickerProviderStateMixin {
  MyListingCubit myListingCubit = MyListingCubit(myListingRepo: MyListingRepo.instance);
  AppCarouselCubit appCarouselCubit = AppCarouselCubit(appCarouselRepository: AppCarouselRepository.instance);
  final scrollController = ScrollController();
  int currentPage = 0;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            myListingCubit.hasNextPage &&
            currentPage == 0) {
          myListingCubit.fetchMyListingItems(search: '');
        } else if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            myListingCubit.hasInsightNextPage &&
            currentPage == 1) {
          myListingCubit.insightPaginatedData();
        } else if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            myListingCubit.hasBookmarkNextPage &&
            currentPage == 2) {
          myListingCubit.fetchBookMarkItems(search: '');
        } else if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            myListingCubit.hasRatingNextPage &&
            currentPage == 3) {
          myListingCubit.fetchRatings(search: '');
        }
      }
    });
    super.initState();
    myListingCubit.init(false);
    appCarouselCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyListingCubit, MyListingState>(
      bloc: myListingCubit,
      builder: (context, state) {
        if (state is MyListingLoadedState) {
          currentPage = state.selectedIndex ?? 0;
          return Stack(
            children: [
              Container(
                color: AppColors.primaryColor,
                child: SafeArea(
                  bottom: false,
                  child: Scaffold(
                    backgroundColor: AppColors.whiteColor,
                    appBar: AppBar(
                      elevation: 2,
                      surfaceTintColor: AppColors.whiteColor,
                      backgroundColor: AppColors.whiteColor,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: InkWell(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.categoryIconBgColor,
                            child: ReusableWidgets.createSvg(path: AssetPath.categorySvgIcon),
                          ),
                        ),
                      ),
                      centerTitle: true,
                      title: Text(
                        AppConstants.myListingStr,
                        style: FontTypography.appBarStyle,
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IconButton(
                              icon: ReusableWidgets.createSvg(
                                  path: AssetPath.searchIconSvg,
                                  size: 22, // Adjust the size if needed
                                  color: AppColors.blackColor),
                              onPressed: () async {
                                var categoryData = await PreferenceHelper.instance.getCategoryList();
                                var categoriesList = categoryData.result;
                                AppRouter.push(AppRoutes.searchScreenRoute,
                                    args: {ModelKeys.categoriesList: categoriesList});
                              }),
                        )
                      ],
                    ),
                    body: RefreshIndicator(
                      backgroundColor: AppColors.whiteColor,
                      color: AppColors.primaryColor,
                      onRefresh: () async {
                        switch (state.selectedIndex) {
                          case 0:
                            // Used for clear text on pull to refresh in listings.
                            if (myListingCubit.searchTxtController.text.isNotEmpty) {
                              myListingCubit.searchTxtController.text = '';
                            }
                            await myListingCubit.fetchMyListingItems(isRefresh: true);
                          case 1:
                            if (myListingCubit.insightSearchTxtController.text.isNotEmpty) {
                              myListingCubit.insightSearchTxtController.text = '';
                            }
                            await myListingCubit.insightPaginatedData(isRefresh: true);
                          case 2:
                            await myListingCubit.fetchBookMarkItems(isRefresh: true);
                          case 3:
                            await myListingCubit.fetchRatings(isRefresh: true);
                          default:
                            return;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(), // <-- Important
                          controller: scrollController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Carousel Slider
                              AppCarouselView(onItemClick: () => AppRouter.push(AppRoutes.itemDetailsViewRoute)),
                              sizedBox20Height(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _tabButton(context, 0, AssetPath.listingFilterIcon, AppConstants.listingStr,
                                        state.selectedIndex),
                                    _tabButton(context, 1, AssetPath.barChartIcon, AppConstants.insightStr,
                                        state.selectedIndex),
                                    _tabButton(context, 2, AssetPath.bookmarkIcon, AppConstants.bookmarkStr,
                                        state.selectedIndex),
                                    _tabButton(
                                        context, 3, AssetPath.starIcon, AppConstants.ratingStr, state.selectedIndex),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),
                              myListingTabBody(selectedTab: state.selectedIndex, state: state),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              state.loader ? const LoaderView() : const SizedBox.shrink()
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _tabButton(BuildContext context, int index, String path, String label, int? selectedIndex) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        myListingCubit.selectTab(index);
      },
      child: Container(
        // width: 86,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? AppColors.primaryColor : AppColors.locationButtonBackgroundColor,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.locationButtonBackgroundColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableWidgets.createSvg(
                path: path, size: 14, color: isSelected ? AppColors.whiteColor : AppColors.blackColor),
            const SizedBox(width: 7),
            Text(
              label,
              maxLines: 1,
              style: isSelected
                  ? FontTypography.defaultTextStyle.copyWith(color: AppColors.whiteColor, fontSize: 12)
                  : FontTypography.defaultTextStyle.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget myListingTabBody({int? selectedTab, required MyListingLoadedState state}) {
    switch (selectedTab) {
      case 0:
        return MyListingFilter(myListingCubit: myListingCubit, scrollController: scrollController);
      case 1:
        return MyListingInsights(myListingCubit: myListingCubit, myListingLoadedState: state);
      case 2:
        return MyListingBookmark(myListingCubit: myListingCubit);
      case 3:
        return MyListingRating(myListingCubit: myListingCubit);
      default:
        return const SizedBox.shrink();
    }
  }
}
