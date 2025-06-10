import 'package:flutter/material.dart';
import 'package:workapp/src/domain/models/my_listing_model.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/listing_card.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// A dynamic grid view widget that supports customizable rows, scroll direction,
/// and additional features like delete and bookmark icons.
class DynamicGridView extends StatelessWidget {
  /// List of items to be displayed in the grid
  final List<MyListingItems>? myListingItems;

  /// Padding for the grid
  final EdgeInsetsGeometry? padding;

  /// Whether to show the delete icon on grid items
  final bool showDeleteIcon;

  /// Whether to show the bookmark icon on grid items
  final bool showBookmarkIcon;

  /// Indicates if the grid is part of "My Listings" feature
  final bool isFromMyListing;

  /// Callback for item click events
  final Function()? onItemClick;

  /// Callback for delete item click events
  final Function()? onDeleteItemClick;

  /// Callback for bookmark item click events
  final Function()? onBookmarkItemClick;

  /// Cubit for managing the state of "My Listings"
  final MyListingCubit? myListingCubit;

  /// Number of items to display per row
  final int itemsPerRow;

  /// Scroll direction of the grid
  final Axis scrollDirection;

  /// Padding around the grid
  final EdgeInsets? gridPadding;

  /// Build context to manage layout
  final BuildContext context;

  /// Custom widgets to be displayed instead of the default grid
  final List<Widget>? children;

  /// Constructor for the `DynamicGridView` widget
  const DynamicGridView({
    super.key,
    required this.itemsPerRow,
    this.scrollDirection = Axis.vertical,
    this.showDeleteIcon = false,
    this.showBookmarkIcon = false,
    this.onDeleteItemClick,
    this.padding,
    this.onBookmarkItemClick,
    this.onItemClick,
    this.myListingItems,
    this.myListingCubit,
    this.gridPadding,
    this.children,
    required this.context,
    required this.isFromMyListing,
  });

  @override
  Widget build(BuildContext context) {
    /// Building grid items from the provided `children` or by generating them dynamically
    final gridItems = children ?? _buildGridWithCustomViews();

    return SingleChildScrollView(
      padding: gridPadding,
      child: Column(children: gridItems),
    );
  }

  /// Generates a grid layout dynamically with custom views or grid items
  List<Widget> _buildGridWithCustomViews() {
    final widgets = <Widget>[];

    /// Check if there are items to display
    if (myListingItems != null && myListingItems!.isNotEmpty) {
      for (var i = 0; i < myListingItems!.length; i += itemsPerRow) {
        /// Adding a billboard view if the item is flagged as a billboard
        if (i < myListingItems!.length && myListingItems![i].isBillBoard == true) {
          widgets.add(_buildCustomView(item: myListingItems![i]));
          widgets.add(const SizedBox(height: 12)); // Spacing between rows
          i++;
        }

        /// Generating a list of widgets for the current row
        final rowItems = List<Widget>.generate(itemsPerRow, (index) {
          final currentIndex = i + index;
          if (currentIndex < myListingItems!.length) {
            return _buildGridItem(item: myListingItems![currentIndex]);
          } else {
            return const SizedBox.shrink(); // Empty space for missing items
          }
        });

        /// Adding the row of grid items
        widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowItems,
          ),
        );
        widgets.add(const SizedBox(height: 12)); // Spacing between rows
      }
    }

    return widgets;
  }

  /// Builds an individual grid item with the provided `item`
  Widget _buildGridItem({required MyListingItems item}) {
    /// Calculating item size based on screen width and number of items per row
    double imageSize = (MediaQuery.sizeOf(context).width - 30) / itemsPerRow;

    return SizedBox(
      height: imageSize + 60,
      width: imageSize,
      child: ListingCard(
        myListingItem: item,
        onItemClick: onItemClick,
        showDeleteIcon: showDeleteIcon,
        onDeleteItemClick: onDeleteItemClick,
        isFromMyListing: isFromMyListing,
      ),
    );
  }

  /// Builds a custom view, such as a billboard banner, for specific items
  Widget _buildCustomView({required MyListingItems item}) {
    /// Setting the billboard size to match screen width
    double billBoardSize = MediaQuery.of(context).size.width;
    return SizedBox(
      width: billBoardSize,
      height: billBoardSize *0.72,
      child: AppUtils.simpleBanner(bannerUrl: item.logo ?? ''),
    );
  }
}
