import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/item_details/cubit/item_details_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/listing_grid.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 17-09-2024
/// @Message : [ShopView]

///This view is to display items from same seller
///It is displayed below item details with tab view and also checks if items are in odd number or even if items are
///in odd than it will allow to add item from same place and if items are in even number it will display same in grid
/// view.

class ShopView extends StatefulWidget {
  final ItemDetailsLoadedState state;
  final ItemDetailsCubit cubit;
  final String categoryName;
  final int itemId;
  final ScrollController scrollController;

  const ShopView(
      {super.key,
      required this.state,
      required this.cubit,
      required this.categoryName,
      required this.itemId,
      required this.scrollController});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.atEdge) {
        if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent &&
            widget.cubit.hasNextPage) {
          widget.cubit.shopItem(listingId: widget.itemId, categoryName: widget.categoryName);
        }
      }
    });
    widget.cubit.shopItem(listingId: widget.itemId, categoryName: widget.categoryName);
    super.initState();
  }

  final StreamController<bool> _streamControllerClearBtn = StreamController<bool>.broadcast();

  Stream<bool> get _streamClearBtn => _streamControllerClearBtn.stream;

  final searchTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final items = widget.state.listingItems;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: _searchView(),
          ),
          sizedBox20Height(),

          // Conditionally show ListingsGrid or "No items" message
          if (items == null || items.isEmpty)
            Center(
              child: Text(
                AppConstants.noItemsStr,
                style: FontTypography.defaultTextStyle,
              ),
            )
          else
            ListingsGrid(
              myListingItems: items,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              hasDummyItem:
              widget.state.listings != null && widget.state.listings!.length % 2 == 1,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              onItemClick: () => AppRouter.pushReplacement(AppRoutes.itemDetailsViewRoute),
              isFromMyListing: true,
            ),

          sizedBox20Height(),
        ],
      ),
    );
  }

  ///Search text field using custom app text field
  Widget _searchView() {
    return AppTextField(
      height: 39,
      hintTxt: AppConstants.searchStr,
      hintStyle: FontTypography.textFieldBlackStyle.copyWith(fontSize: 14.0),
      onChanged: (value) => _streamControllerClearBtn.add(value.isNotEmpty),
      suffixIconConstraints: const BoxConstraints(
        minHeight: 25,
        maxHeight: 39,
        minWidth: 100,
        maxWidth: 100,
      ),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder(
            stream: _streamClearBtn,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data ?? false) {
                return InkWell(
                  /// clear data on tap of clear button
                  onTap: () {
                    _streamControllerClearBtn.add(false);
                    searchTxtController.clear();
                    onSearchClick();
                  },
                  child: SizedBox(
                    height: 39,
                    width: 35,
                    child: Icon(Icons.clear, color: AppColors.jetBlackColor),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          InkWell(
            ///search data on click of search button
            onTap: () {
              if (searchTxtController.text.trim().isNotEmpty) {
                onSearchClick();
              } else {
                AppUtils.showSnackBar(
                  AppConstants.searchHintStr,
                  SnackBarType.alert,
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              height: 39,
              child: ReusableWidgets.createSvg(
                width: 15,
                height: 15,
                path: AssetPath.searchIconSvg,
              ),
            ),
          ),
        ],
      ),
      controller: searchTxtController,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onSubmit: (value) {
        if (searchTxtController.text.trim().isNotEmpty) {
          onSearchClick();
        } else {
          AppUtils.showSnackBar(AppConstants.searchHintStr, SnackBarType.alert);
        }
      },
      fillColor: AppColors.locationButtonBackgroundColor,
    );
  }

  void onSearchClick() {
    widget.cubit.currentPage = 1;
    widget.cubit.shopItem(
      categoryName: widget.categoryName,
      listingId: widget.itemId,
      search: searchTxtController.text.trim(),
      isRefresh: true,
    );
  }
}
