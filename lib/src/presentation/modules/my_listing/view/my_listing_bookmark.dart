import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/app_carousel_exports.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/listing_grid.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/09/24
/// @Message : [MyListingBookmark]
///
/// The `MyListingBookmark`  class provides a user interface to display list of item added in bookmark by the user.
/// Each Item Has Item image, title, category,price, location
class MyListingBookmark extends StatelessWidget {
  final MyListingCubit myListingCubit;

  MyListingBookmark({super.key, required this.myListingCubit});

  final StreamController<bool> _streamControllerClearBtn = StreamController<bool>.broadcast();

  Stream<bool> get _streamClearBtn => _streamControllerClearBtn.stream;

  final searchTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyListingCubit, MyListingState>(
      bloc: myListingCubit,
      builder: (context, state) {
        if (state is MyListingLoadedState) {
          if (state.bookmarkSearchText!.isNotEmpty) {
            _streamControllerClearBtn.add(true);
            searchTxtController.text = state.bookmarkSearchText!;
          } else {
            _streamControllerClearBtn.add(false);
          }

          return SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _searchWidget(),
                  const SizedBox(height: 20),
                  state.myBookmarkListingItem == null || state.myBookmarkListingItem!.isEmpty
                      ? Center(
                          child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle),
                        )
                      : ListingsGrid(
                          isFromMyListing: true,
                          needScrolling: false,
                          myListingItems: state.myBookmarkListingItem,
                          showBookmarkIcon: true,
                          myListingCubit: myListingCubit,
                        ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _searchWidget() {
    return AppTextField(
      height: 45,
      hintTxt: AppConstants.findMyBookMarks,
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
              onSearchClick();
              // No need of this code
              /*if (searchTxtController.text.trim().isNotEmpty) {
                onSearchClick();
              } else {
                AppUtils.showSnackBar(
                  AppConstants.searchHintStr,
                  SnackBarType.alert,
                );
              }*/
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
        onSearchClick();
        // No need of this code
        /*if (searchTxtController.text.trim().isNotEmpty) {
          onSearchClick();
        } else {
          AppUtils.showSnackBar(AppConstants.searchHintStr, SnackBarType.alert);
        }*/
      },
      fillColor: AppColors.locationButtonBackgroundColor,
    );
  }

  void onSearchClick() {
    myListingCubit.bookmarkCurrentPage = 1;
    myListingCubit.fetchBookMarkItems(
      search: searchTxtController.text.trim(),
      isRefresh: true,
    );
  }

  Widget locationRowWidget(String time, String location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 1, child: ReusableWidgets.createSvg(path: AssetPath.mapIcon, size: 10)),
              sizedBox5Width(),
              Expanded(
                flex: 9,
                child: Text(
                  time,
                  style: FontTypography.itemDetailsGridViewStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        sizedBox10Width(),
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 1, child: ReusableWidgets.createSvg(path: AssetPath.timeIcon, size: 10)),
              sizedBox5Width(),
              Expanded(
                flex: 9,
                child: Text(
                  location,
                  style: FontTypography.itemDetailsGridViewStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bookmarkButton(
      {required String assetPath,
      required Function() onPressed,
      required double height,
      required double width,
      required Color backgroundColor}) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: AppColors.backgroundColor, // White background for the button
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5), // Button padding
              elevation: 3, // Elevation for shadow effect
            ),
            onPressed: onPressed,
            child: ReusableWidgets.createSvg(path: AssetPath.bookmarkFilledIcon, size: 14)),
      ),
    );
  }
}
