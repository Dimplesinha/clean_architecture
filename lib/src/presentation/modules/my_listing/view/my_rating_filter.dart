import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';

import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

import 'package:workapp/src/presentation/style/style.dart';

class MyRatingFilter extends StatefulWidget {
  final MyListingLoadedState state;
  final MyListingCubit myListingCubit;
  const MyRatingFilter({super.key, required this.state, required this.myListingCubit});

  @override
  State<MyRatingFilter> createState() => _MyRatingFilterState();
}

class _MyRatingFilterState extends State<MyRatingFilter> {
  final listingViewType = {
    EnumType.myItemRating: AppConstants.myItemRatingsStr,
    EnumType.myRatings: AppConstants.myRatingsStr,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 38),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstants.ratingFilter,
              style: FontTypography.bottomSheetHeading,
            ),
            const LabelText(
              title: AppConstants.ratingListViewType,
              isRequired: false,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<int>(
                isExpanded: true,
                hint: Text(AppConstants.selectRatingViewType, style: FontTypography.textFieldHintStyle),
                customButton: Container(
                  height: AppConstants.constTxtFieldHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(constBorderRadius),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: Text(
                          listingViewType[widget.state.selectedRatingType] ?? AppConstants.selectRatingViewType,
                          style: FontTypography.textFieldBlackStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      SvgPicture.asset(AssetPath.iconDropDown),
                    ],
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                  ),
                ),
                items: listingViewType.entries.map(
                      (entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        style: FontTypography.textFieldBlackStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ).toList(),
                value: widget.state.selectedRatingType,
                onChanged: (value) {
                  widget.myListingCubit.ratingVisibility(value ?? 0);
                  navigatorKey.currentState?.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


