import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/my_contact_user_listing/cubit/my_contact_user_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_contact_user_listing/repo/my_contact_user_listing_repo.dart';
import 'package:workapp/src/presentation/modules/my_contact_user_listing/view/my_contact_user_listing.dart';
import 'package:workapp/src/presentation/modules/my_contact_user_listing/view/my_contact_user_past_listing.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/style/style.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 25/03/25
/// @Message : [MyContactUserListingTab]
///
/// The `MyListing`  class provides a user interface for performing my listing consist of tab bar view and all item view
///with tab bar of listing insights, bookmark,
class MyContactUserListingTab extends StatefulWidget {
  String? title;
  int? userId;

  MyContactUserListingTab({
    super.key,
    this.title,
    this.userId,
  });

  @override
  State<MyContactUserListingTab> createState() => _MyContactUserListingTabState();
}

class _MyContactUserListingTabState extends State<MyContactUserListingTab> with SingleTickerProviderStateMixin {
  MyContactUserListingCubit myContactUserListingCubit =
      MyContactUserListingCubit(myContactUserListingRepo: MyContactUserListingRepo.instance);
  final scrollController = ScrollController();
  int currentPage = 0;

  @override
  void initState() {
    myContactUserListingCubit.userId = widget.userId;
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            myContactUserListingCubit.hasNextPage &&
            currentPage == 0) {
          myContactUserListingCubit.fetchMyListingItems(search: '');
        } else if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            myContactUserListingCubit.hasPastListingsPage &&
            currentPage == 1) {
          myContactUserListingCubit.fetchContactUserPastListing(search: '');
        }
      }
    });
    super.initState();
    myContactUserListingCubit.init(false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyContactUserListingCubit, MyContactUserListingState>(
      bloc: myContactUserListingCubit,
      builder: (context, state) {
        if (state is MyContactUserListingLoadedState) {
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
                      centerTitle: true,
                      title: Text(
                        widget.title ?? '',
                        style: FontTypography.appBarStyle,
                      ),
                    ),
                    body: RefreshIndicator(
                      backgroundColor: AppColors.whiteColor,
                      color: AppColors.primaryColor,
                      onRefresh: () async {
                        switch (state.selectedIndex) {
                          case 0:
                            await myContactUserListingCubit.fetchMyListingItems(isRefresh: true);
                          case 1:
                            await myContactUserListingCubit.fetchContactUserPastListing(isRefresh: true);
                          default:
                            return;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _tabButton(
                                    context,
                                    0,
                                    AppConstants.allActiveListings,
                                    state.selectedIndex,
                                  ),
                                  sizedBox10Width(),
                                  _tabButton(
                                    context,
                                    1,
                                    AppConstants.pastListings,
                                    state.selectedIndex,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(child: myListingTabBody(selectedTab: state.selectedIndex, state: state)),
                          ],
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

  Widget _tabButton(BuildContext context, int index, String label, int? selectedIndex) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        myContactUserListingCubit.selectTab(index);
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

  Widget myListingTabBody({int? selectedTab, required MyContactUserListingLoadedState state}) {
    switch (selectedTab) {
      case 0:
        return MyContactUserListing(
            myContactUserListingCubit: myContactUserListingCubit, scrollController: scrollController);
      case 1:
        return MyContactUserPastListing(
            myContactUserListingCubit: myContactUserListingCubit, scrollController: scrollController);
      default:
        return const SizedBox.shrink();
    }
  }
}
