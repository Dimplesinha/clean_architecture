import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/view/app_carousel.dart';
import 'package:workapp/src/presentation/modules/item_details/view/item_details_views.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';
import 'package:workapp/src/presentation/modules/message/view/contact_view/contact_inidividual.dart';
import 'package:workapp/src/presentation/modules/message/view/message_list.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/utils/signalr_helper.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [MessageListing]
///
/// The `MessageListing` class provides for displaying messages, inquiries, and contacts
/// in a tabbed format, with a page view to switch between these categories.
///
/// Responsibilities:
/// Base View to Fetch Message, Enquiry and Contact
class MessageListing extends StatefulWidget {
  const MessageListing({super.key});

  @override
  State<MessageListing> createState() => _MessageListingState();
}

class _MessageListingState extends State<MessageListing> with SingleTickerProviderStateMixin {
  MessageCubit messageCubit = MessageCubit();
  late ScrollController _scrollController;
  late final StreamSubscription<int> _messageRefreshSubscription;
  late final StreamSubscription<int> _chatRefreshSubscription;


  // final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && messageCubit.hasNextPage) {
        messageCubit.fetchContactList(isRefresh: false, isSwipe: false);
      }
    });
    messageCubit.fetchContactList(isRefresh: false, isSwipe: false);
    messageCubit.fetchItems();
    _messageRefreshSubscription = SignalRHelper.instance.refreshMessageStream.listen((event) {
      messageCubit.fetchItems();
    });
    _chatRefreshSubscription = SignalRHelper.instance.unreadMessageCountStream.listen((event) {
      messageCubit.fetchItems();
    });
  }

  @override
  void dispose() {
    // _pageController.dispose();
    _messageRefreshSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: messageCubit..fetchItems(),
      builder: (context, state) {
        return Container(
          color: AppColors.primaryColor,
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColors.whiteColor,
                  appBar: AppBar(
                    backgroundColor: AppColors.whiteColor,
                    elevation: 0,
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
                    title: Text(
                      AppConstants.messagesStr,
                      style: FontTypography.appBarStyle,
                    ),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: ReusableWidgets.createSvg(
                            path: AssetPath.searchIconSvg,
                            size: 22,
                            color: AppColors.blackColor,
                          ),
                          onPressed: () async {
                            var categoryData = await PreferenceHelper.instance.getCategoryList();
                            var categoriesList = categoryData.result;
                            AppRouter.push(AppRoutes.searchScreenRoute,
                                args: {ModelKeys.categoriesList: categoriesList});
                          },
                        ),
                      ),
                    ],
                  ),
                  body: RefreshIndicator(
                    backgroundColor: AppColors.whiteColor,
                    color: AppColors.primaryColor,
                    onRefresh: () async {
                      switch (state.selectedIndex) {
                        case 0:
                          messageCubit.fetchItems();
                        case 1:
                          messageCubit.contactCurrentPage = 1;
                          await messageCubit.fetchContactList(isRefresh: true, isSwipe: true);
                        default:
                          return;
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCarouselView(
                              onCallback: (){
                                messageCubit.fetchItems();
                              },
                            ),
                            sizedBox20Height(),
                            Container(
                              color: AppColors.whiteColor,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _tabButton(
                                      context, 0, AssetPath.messageIcon, AppConstants.messageStr, state.selectedIndex),
                                  const SizedBox(width: 20),
                                  _tabButton(
                                      context, 1, AssetPath.contactIcon, AppConstants.contactStr, state.selectedIndex),
                                ],
                              ),
                            ),
                            messageTabBody(
                                selectedTab: state.selectedIndex,
                                scrollController: _scrollController,
                                cubit: messageCubit),
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        AppRouter.push(AppRoutes.newMessageScreenRoute);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: AppColors.primaryColor,
                      child: ReusableWidgets.createSvg(
                        size: 28,
                        path: AssetPath.addMessageIcon,
                      ),
                    ),
                  ),
                ),
                state.loader == true ? const LoaderView() : const SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    );
  }

  /// Common Tab view of Message Enquiry and Contact
  Widget _tabButton(BuildContext context, int index, String path, String label, int? selectedIndex) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () async {
          // _pageController.jumpToPage(index);
          messageCubit.selectTab(index);

          if (index == 1) {
            messageCubit.contactCurrentPage = 1;
            await messageCubit.fetchContactList(isRefresh: true, isSwipe: true);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? AppColors.primaryColor : AppColors.locationButtonBackgroundColor,
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : AppColors.locationButtonBackgroundColor,
            ),
          ),
          child: Row(
            children: [
              ReusableWidgets.createSvg(path: path, color: isSelected ? AppColors.whiteColor : AppColors.blackColor),
              const SizedBox(width: 8),
              Text(
                label,
                maxLines: 1,
                style: isSelected
                    ? FontTypography.defaultTextStyle.copyWith(color: AppColors.whiteColor)
                    : FontTypography.defaultTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageTabBody({int? selectedTab, required ScrollController scrollController, required MessageCubit cubit}) {
    switch (selectedTab) {
      case 0:
        return MessageView(
          scrollController: scrollController,
          state: cubit.state,
        );
      case 1:
        return ContactIndividualScreen(cubit.state, messageCubit);
      default:
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

}

// Add this new delegate class
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
