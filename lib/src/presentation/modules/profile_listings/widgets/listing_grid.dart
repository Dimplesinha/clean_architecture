import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/account_type_change/cubit/account_type_change_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/listing_card.dart';
import 'package:workapp/src/presentation/modules/subscription/cubit/subscription_cubit.dart';
import 'package:workapp/src/utils/custom_grid_view.dart';
import 'package:workapp/src/utils/utils.dart';

class ListingsGrid extends StatelessWidget {
  final List<MyListingItems>? myListingItems;
  final bool hasDummyItem;
  final bool needScrolling;
  final ScrollPhysics? scrollPhysics;
  final EdgeInsetsGeometry? padding;
  final bool showDeleteIcon;
  final bool chooseListing;
  final bool showBookmarkIcon;
  final bool showCheckBox;
  final bool isFromMyListing;
  final Function()? onItemClick;
  final Function()? onDeleteItemClick;
  final Function()? onBookmarkItemClick;
  final MyListingCubit? myListingCubit;
  final AccountTypeChangeCubit? accountTypeChangeCubit;
  final AccountTypeChangeLoadedState? accountTypeChangeLoadedState;
  final SubscriptionCubit? subscriptionCubit;
  final SubscriptionLoadedState? subscriptionLoadedState;

  const ListingsGrid({
    super.key,
    this.hasDummyItem = false,
    this.needScrolling = true,
    this.showDeleteIcon = false,
    this.showBookmarkIcon = false,
    this.showCheckBox = false,
    this.chooseListing = false,
    this.onDeleteItemClick,
    this.scrollPhysics,
    this.padding,
    this.onBookmarkItemClick,
    this.onItemClick,
    this.myListingItems,
    this.myListingCubit,
    this.accountTypeChangeCubit,
    this.accountTypeChangeLoadedState,
    this.subscriptionCubit,
    this.subscriptionLoadedState,
    required this.isFromMyListing,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> gridItems;
    if (isFromMyListing == true) {
      gridItems = [
        ...?myListingItems?.map(
          (myListingItems) => ListingCard(
            myListingItem: myListingItems,
            showDeleteIcon: showDeleteIcon,
            onDeleteItemClick: onDeleteItemClick,
            onBookmarkItemClick: onBookmarkItemClick,
            isFromMyListing: isFromMyListing,
            showBookmarkIcon: showBookmarkIcon,
            showCheckBox: showCheckBox,
            chooseListing: chooseListing,
            myListingCubit: myListingCubit,
            accountTypeChangeCubit: accountTypeChangeCubit,
            accountTypeChangeLoadedState: accountTypeChangeLoadedState,subscriptionCubit: subscriptionCubit,
            subscriptionLoadedState: subscriptionLoadedState,
          ),
        )
      ];
    } else {
      gridItems = [
        ...?myListingItems?.map((listing) {
          // Display a regular listing card
          return ListingCard(
            myListingItem: listing,
            onItemClick: onItemClick,
            showDeleteIcon: showDeleteIcon,
            onDeleteItemClick: onDeleteItemClick,
            isFromMyListing: isFromMyListing,
            accountTypeChangeCubit: accountTypeChangeCubit,
            subscriptionLoadedState:subscriptionLoadedState,
            subscriptionCubit:subscriptionCubit,
            showBookmarkIcon: showBookmarkIcon,
          );
        }),
      ];
      if (hasDummyItem) {
        gridItems.add(const EmptyListingCard()); // Add a dummy item
      }
    }

    return isFromMyListing
        ? GridView.count(
            padding: padding ?? const EdgeInsets.only(bottom: 20),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.78,
            shrinkWrap: true,
            physics: needScrolling
                ? scrollPhysics
                : const NeverScrollableScrollPhysics(),
            children: gridItems,
          )
        : DynamicGridView(
            itemsPerRow: 2,
            scrollDirection: Axis.vertical,
            isFromMyListing: isFromMyListing,
            showDeleteIcon: showDeleteIcon,
            onDeleteItemClick: onDeleteItemClick,
            onBookmarkItemClick: onBookmarkItemClick,
            showBookmarkIcon: showBookmarkIcon,
            myListingCubit: myListingCubit,
            myListingItems: myListingItems,
            context: context,
            gridPadding: const EdgeInsets.symmetric(horizontal: 10),
          );
  }

  List<StaggeredGridTile> buildTiles() {
    final combinedListings = myListingItems?.map((listing) {
      if (listing.isBillBoard == true) {
        return listing; // Billboard listing
      } else {
        return listing; // Non-billboard listing
      }
    }).toList();

    return List.generate(combinedListings?.length ?? 0, (index) {
      if (combinedListings?[index].isBillBoard == true) {
        return StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: _buildFullWidthItem(combinedListings?[index]),
        );
      } else {
        return StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Padding(
            padding: padding ?? const EdgeInsets.only(bottom: 20),
            child: _buildGridItem(combinedListings?[index]),
          ),
        );
      }
    });
  }

  Widget _buildGridItem(MyListingItems? listing) {
    return ListingCard(
      myListingItem: listing,
      onItemClick: onItemClick,
      showDeleteIcon: showDeleteIcon,
      onDeleteItemClick: onDeleteItemClick,
      isFromMyListing: isFromMyListing,
    );
  }

  Widget _buildFullWidthItem(MyListingItems? item) {
    return SizedBox(
        width: MediaQuery.of(navigatorKey.currentState!.context).size.width,
        child: AppUtils.simpleBanner(bannerUrl: item?.logo ?? ''));
  }
}

/// EmptyListingCard for displaying add item button with app logo
/// This is added for use of displaying it on grid view in item details shop tab.
/// This is displayed on last of the item list when list ends and odd length.
class EmptyListingCard extends StatelessWidget {
  const EmptyListingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      width: MediaQuery.of(context).size.width / 2,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.locationButtonBackgroundColor,
        borderRadius: BorderRadius.circular(constBorderRadius),
      ),
      child: Column(
        children: [
          Expanded(
              child: ReusableWidgets.createSvg(
                  path: AssetPath.workappLogoBlue, size: 50.0)),
          AppButton(function: () {}, title: AppConstants.addItemStr),
        ],
      ),
    );
  }
}
