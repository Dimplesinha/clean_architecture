import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/style/style.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09-09-2024
/// @Message : [SortByBottomSheet]


///Sort By Bottom Sheet is used on screens where list of items are displayed and we want to sort it by price from
///high to low or low to high.
/// This view can be accessed from search screen where we have sort by option on bottom.
///
/// Responsibility:
/// - Display to sorting option with sorting function call.
class SortByBottomSheet extends StatefulWidget {
  const SortByBottomSheet({super.key});

  @override
  State<SortByBottomSheet> createState() => _SortByBottomSheetState();
}

class _SortByBottomSheetState extends State<SortByBottomSheet> {

  ///Container view with 2 options for sorting, divider and title
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 36),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          sizedBox8Height(),
          const Divider(
            thickness: 6,
            endIndent: 150,
            indent: 150,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
            child: Text(
              AppConstants.sortBySmallStr.toUpperCase(),
              style: FontTypography.sortByTitle,
            ),
          ),
          Divider(
            color: AppColors.borderColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: InkWell(
              onTap: () {
                ///For calling sorting function on screen when clicked on this option
                // sortByPriceHighToLow(items);
                AppRouter.pop();
              },
              child: Text(
                AppConstants.priceHighToLow,
                style: FontTypography.basicDetailsTextFieldStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0),
            child: InkWell(
              onTap: () {
                ///For calling sorting function on screen when clicked on this option
                // sortByPriceLowToHigh(items);
                AppRouter.pop();
              },
              child: Text(
                AppConstants.priceLowToHigh,
                style: FontTypography.basicDetailsTextFieldStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Sort by high to low function used to sorting item when clicked on high to low option
/*  List<Item> sortByPriceHighToLow(List<Item> items) {
    items.sort((a, b) => b.price.compareTo(a.price));
    return items;
  }*/

  ///Sort by low to high function used to sorting item when clicked on low to high option
/*List<Item> sortByPriceLowToHigh(List<Item> items) {
    items.sort((a, b) => a.price.compareTo(b.price));
    return items;
  }*/
}
