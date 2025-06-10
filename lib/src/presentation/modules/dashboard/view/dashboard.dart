import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/account_type_change/view/account_type_dialog.dart';
import 'package:workapp/src/presentation/modules/app_carousel/view/app_carousel.dart';
import 'package:workapp/src/presentation/modules/bottom_sheet/view/bottom_sheet_screen.dart';
import 'package:workapp/src/presentation/modules/dashboard/bloc/dashboard_cubit.dart';
import 'package:workapp/src/presentation/modules/dashboard/repo/dashboard_repo.dart';
import 'package:workapp/src/presentation/modules/item_details/cubit/item_details_cubit.dart';
import 'package:workapp/src/presentation/modules/item_details/repo/item_details_repo.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/listing_grid.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/my_location_type_stream.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03/09/24
/// @Message : [Dashboard]
///
/// The `Dashboard`  class provides a user interface to display where they can view a list of
/// ads featuring images, categories, titles, prices, locations, and posting durations.
///
/// Responsibility :
/// User can filter ads based on location filters such as "Near Me," "Countrywide," and "Worldwide,"
/// as well as by selected categories.
/// Selecting any ad item directs users to a detailed screen where they can find comprehensive information about that ad item.
/// Users can navigate to the search screen by tapping on the search icon located in the top right corner.
///Has a bottom sheet to select account type personal or business
class Dashboard extends StatefulWidget {
  Function(bool?) drawerIconEnableCallback;

  Dashboard({super.key, required this.drawerIconEnableCallback});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin {
  DashboardCubit dashboardCubit = DashboardCubit(dashboardRepository: DashboardRepository.instance);
  bool _isDialogShown = false;
  final AppLinks _appLinks = AppLinks();
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _handleDeepLink();
    verticalScrollController.addListener(() {
      if (verticalScrollController.position.atEdge) {
        if (verticalScrollController.position.pixels == verticalScrollController.position.maxScrollExtent &&
            dashboardCubit.hasNextPage) {
          dashboardCubit.fetchItems(
            isFromInitialCall: false,
          );
        }
      }
      dashboardCubit.updateScrollPosition(verticalScrollController.offset);
    });
    super.initState();
    dashboardCubit.init();
    // Check app carousal height
    dashboardCubit.updateCarousalHeight(null, context);
  }

  @override
  void dispose() {
    super.dispose();
    verticalScrollController.dispose();
    horizontalScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<DashboardCubit, DashboardState>(
      bloc: dashboardCubit,
      builder: (context, state) {
        if (state is DashboardLoadedState) {
          if (dashboardCubit.totalApiCount == 2) {
            widget.drawerIconEnableCallback(true);
          } else {
            widget.drawerIconEnableCallback(false);
          }

          if ((AppUtils.loginUserModel?.accountTypeValue == null || AppUtils.loginUserModel?.accountTypeValue == '0') &&
              dashboardCubit.check == true &&
              !_isDialogShown) {
            print(
                '_DashboardState.build${AppUtils.loginUserModel?.accountTypeValue}${AppUtils.loginUserModel?.accountTypeValue}${dashboardCubit.check}${_isDialogShown}');
            _isDialogShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAccountTypeBottomSheet(context, dashboardCubit);
            });
          }

          return Stack(
            children: [
              RefreshIndicator(
                backgroundColor: AppColors.backgroundColor,
                color: AppColors.primaryColor,
                onRefresh: () async {
                  MasterDataAPI.getCountries();
                  await dashboardCubit.fetchAllCategories(isRefresh: true);
                  dashboardCubit.currentPage = 1;
                  dashboardCubit.isAllCategorySelected = true;
                  await dashboardCubit.fetchItems(
                    isRefresh: true,
                    isFromInitialCall: false,
                  );
                },
                child: CustomScrollView(
                  controller: verticalScrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // SliverAppBar for tabs and carousel
                    SliverAppBar(
                      elevation: 0,
                      shadowColor: Colors.black45,
                      automaticallyImplyLeading: false,
                      floating: true,
                      pinned: false,
                      // Changed to true to keep app bar visible
                      snap: true,
                      expandedHeight: state.appCarousalHeight ?? 0,
                      //((MediaQuery.of(context).size.width - 30) / 2) + 140, // Comment for future reference
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin, // Smooth collapsing effect
                        background: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tab items for location, categories, and premium
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  StreamBuilder<String>(
                                    stream: LocationTypeStream.instance.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return createTabItem(
                                          path: state.path ?? '',
                                          title: (snapshot.data ?? '') == AppConstants.worldwideStr
                                              ? AppConstants.worldStr
                                              : (snapshot.data ?? '') == AppConstants.nearMeStr
                                                  ? AppConstants.nearMe
                                                  : AppConstants.countryStr,
                                          onTabClicked: () {
                                            AppUtils.showBottomSheetForDashboard(
                                              context,
                                              child: BottomSheetScreen(
                                                isFromCategory: false,
                                                dashboardCubit: dashboardCubit,
                                                callBackOnTap: () async {
                                                  dashboardCubit.currentPage = 1;
                                                  await dashboardCubit.fetchItems(
                                                    isFromChangedCategory: true,
                                                    isFromInitialCall: false,
                                                  );
                                                },
                                              ),
                                              onCancel: () {
                                                dashboardCubit.setInitialSelectedOption(
                                                    state.selectedSingleOption, state.path);
                                              },
                                            );
                                          },
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  // Category
                                  createTabItem(
                                    path: AssetPath.categoriesIcon,
                                    title: AppConstants.categoriesStr,
                                    onTabClicked: () {
                                      AppUtils.showBottomSheetForDashboard(
                                        context,
                                        isDismissible: true,
                                        child: BottomSheetScreen(
                                          isFromCategory: true,
                                          dashboardCubit: dashboardCubit,
                                          callBackOnTap: () async {
                                            dashboardCubit.currentPage = 1;
                                            await dashboardCubit.fetchItems(
                                              isFromChangedCategory: true,
                                              isFromInitialCall: false,
                                            );
                                          },
                                        ),
                                        onCancel: () {
                                          dashboardCubit.setInitialCategory();
                                        },
                                      );
                                    },
                                    showRedDot: !dashboardCubit.isAllCategorySelected,
                                  ),
                                  // Premium
                                  createTabItem(
                                    path: AssetPath.premiumIcon,
                                    title: AppConstants.premiumStr,
                                    onTabClicked: () async {
                                      bool isLoggedIn = await PreferenceHelper.instance
                                          .getPreference(key: PreferenceHelper.isLogin, type: bool);
                                      if (isLoggedIn == true) {
                                        navigatorKey.currentState?.pushNamed(AppRoutes.subscriptionRoute);
                                      } else {
                                        AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Carousel Slider
                            AppCarouselView(
                              onItemClick: () => AppRouter.push(AppRoutes.itemDetailsViewRoute),
                              onItemListResult: (response) => {
                                // Update the height of the carousel
                                dashboardCubit.updateCarousalHeight(response, context),
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Grid for displaying items
                    SliverToBoxAdapter(
                      child: ListingsGrid(
                        myListingItems: state.items ?? [],
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        hasDummyItem: false,
                        needScrolling: false,
                        onItemClick: () => AppRouter.push(AppRoutes.itemDetailsViewRoute),
                        isFromMyListing: false,
                      ),
                    ),
                  ],
                ),
              ),
              state.isLoading ? const LoaderView() : const SizedBox.shrink(),
              // Floating Action Button for scrolling to top
              if (state.showUpIcon)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _scrollToTop,
                    tooltip: 'Scroll to Top',
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(
                      Icons.arrow_upward,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _scrollToTop() {
    verticalScrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Widget createTabItem({
    required String path,
    required String title,
    Function? onTabClicked,
    bool showRedDot = false,
  }) {
    return InkWell(
      onTap: () => onTabClicked?.call(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.greyUnselectedColor.withAlpha(25), // 0.1 alpha
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ReusableWidgets.createSvg(path: path),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(title),
                  ),
                ],
              ),
            ),
          ),
          if (showRedDot)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleDeepLink() {
    _appLinks.uriLinkStream.listen((uri) async {
      final url = uri.toString();
      debugPrint('onAppLink: ${uri.queryParameters}');

      const prefix = 'listing-detail/';
      const prefixListing = 'list/';

      if (url.contains(prefix) || url.contains(prefixListing)) {
        final matchedPrefix = url.contains(prefix) ? prefix : prefixListing;
        final startIndex = url.indexOf(matchedPrefix) + matchedPrefix.length;
        final endIndex = url.length;

        final listingId = url.substring(startIndex, endIndex).replaceAll('/', '');
        final isNumeric = int.tryParse(listingId) != null;

        if (isNumeric) {
          _navigateToItem(int.parse(listingId));
        } else {
          final itemDetailsCubit = ItemDetailsCubit(itemDetailsRepo: ItemDetailsRepo.instance);
          final decodedLink = await itemDetailsCubit.decodeLink(listingID: listingId);
          final idMatch = RegExp(r'listing-detail/(\d+)').firstMatch(decodedLink);
          if (idMatch != null) {
            final itemId = int.parse(idMatch.group(1)!);
            _navigateToItem(itemId);
          } else {
            debugPrint('Invalid link format: $url');
          }
        }
      }
    });
  }

  void _navigateToItem(int itemId) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == AppRoutes.itemDetailsViewRoute) {
      return;
    }

    AppRouter.push(
      AppRoutes.itemDetailsViewRoute,
      args: {
        ModelKeys.itemId: itemId,
        ModelKeys.formId: 0,
        ModelKeys.category: '',
        ModelKeys.isDraft: false,
        ModelKeys.isAvailableHistory: false,
      },
    );
  }

  void showAccountTypeBottomSheet(BuildContext context, DashboardCubit dashboardCubit) {
    AppUtils.showBottomSheet(
      context,
      enableDrag: false,
      isDismissible: false,
      child: AccountTypeBottomSheet(
        onOkPressed: () {},
      ),
    );
  }
}
