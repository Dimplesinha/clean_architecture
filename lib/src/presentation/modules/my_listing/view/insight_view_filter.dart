import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/app_btn.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/widget/category_widget.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/utils/app_utils.dart';

class InsightViewFilter extends StatefulWidget {
  final MyListingCubit myListingCubit;
  final MyListingLoadedState myListingLoadedState;

  const InsightViewFilter({
    super.key,
    required this.myListingCubit,
    required this.myListingLoadedState,
  });

  @override
  State<InsightViewFilter> createState() => _InsightViewFilterState();
}

class _InsightViewFilterState extends State<InsightViewFilter> {
  CommonDropdownModel? selectedCategory;
  String? selected;
  String? startDate;
  String? endDate;
  bool _resetTapped = false;


  @override
  void initState() {
    if (widget.myListingCubit.insightsCommonDropdownModel != null) {
      selectedCategory = widget.myListingCubit.insightsCommonDropdownModel!;
    } else {
      selectedCategory = CommonDropdownModel(id: 0, name: AppConstants.allStr);
      widget.myListingCubit.insightsCommonDropdownModel = selectedCategory;
    }
    selected = widget.myListingCubit.sortBy;
    startDate = widget.myListingCubit.sortFrom;
    endDate = widget.myListingCubit.sortTo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Container(
              height: 7,
              width: 59,
              decoration: BoxDecoration(
                color: AppColors.bottomSheetBarColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    AppConstants.filterInsightsStr,
                    textAlign: TextAlign.end,
                    style: FontTypography.bottomSheetHeading,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () => resetFilters(),
                    child: Text(
                      AppConstants.reset,
                      textAlign: TextAlign.end,
                      style: selectedCategory != null || selected != null || startDate != null || endDate != null
                          ? FontTypography.planTxtStyle
                          : FontTypography.planTxtStyle.copyWith(color: AppColors.hintStyle),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 28),
            CategoryWidget(
              categoriesList: widget.myListingCubit.categoriesList!,
              hintText: AppConstants.selectCategoryStr,
              label: AppConstants.category,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                  //widget.myListingCubit.selectedCategoryId = category.id;
                });
              },
              reset: selectedCategory == null,
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppConstants.sortByStr,
                style: FontTypography.textFieldBlackStyle,
              ),
            ),
            const SizedBox(height: 9),
            DropDownWidget(
              items: AppConstants.sortByFilterOptions.values.toList(),
              dropDownOnChange: (value) {
                selected = value;
                widget.myListingCubit.sortBy = value;
                setState(() {});
              },
              displaySelectedItem: selected ?? AppConstants.selectSortByStr,
              dropDownValue: selected,
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppConstants.filterByDateStr,
                style: FontTypography.textFieldBlackStyle,
              ),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      widget.myListingCubit.openDatePicker(context, initialDate: startDate).then((onValue) {
                        startDate = onValue;
                        widget.myListingCubit.sortFrom = onValue;
                        if (!widget.myListingCubit.isDateValid(startDate: startDate, endDate: endDate)) {
                          endDate = null;
                          widget.myListingCubit.sortTo = null;
                        }
                        setState(() {});
                      });
                    },
                    child: AppTextField(
                      isReadOnly: true,
                      isEnable: false,
                      hintTxt: AppUtils.formatDateLocal(startDate ?? AppConstants.fromDate),
                      hintStyle:
                          startDate != null ? FontTypography.textFieldBlackStyle : FontTypography.textFieldHintStyle,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
                sizedBox20Width(),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      widget.myListingCubit
                          .openDatePicker(context, initialDate: endDate, selectedStartDate: startDate,isEndDate: true)
                          .then((onValue) {
                        endDate = onValue;
                        widget.myListingCubit.sortTo = onValue;
                        setState(() {});
                      });
                    },
                    child: AppTextField(
                      isReadOnly: true,
                      isEnable: false,
                      hintTxt: AppUtils.formatDateLocal(endDate ?? AppConstants.toDate),
                      hintStyle:
                          endDate != null ? FontTypography.textFieldBlackStyle : FontTypography.textFieldHintStyle,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
              ],
            ),
            sizedBox30Height(),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    function: () {
                      AppRouter.pop(res: AppConstants.cancelStr);
                    },
                    title: AppConstants.cancelStr.toUpperCase(),
                    bgColor: AppColors.whiteColor,
                    textStyle: FontTypography.appBtnStyle.copyWith(color: AppColors.deleteColor),
                    borderColor: AppColors.deleteColor,
                    elevation: 0,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AppButton(
                    function: () {
                      if (_resetTapped) {
                        widget.myListingCubit.insightsCommonDropdownModel = null;
                        widget.myListingCubit.sortBy = null;
                        widget.myListingCubit.sortFrom = null;
                        widget.myListingCubit.sortTo = null;
                      } else {
                        widget.myListingCubit.sortBy = selected;
                        widget.myListingCubit.sortFrom = startDate;
                        widget.myListingCubit.sortTo = endDate;
                        widget.myListingCubit.insightsCommonDropdownModel = selectedCategory;
                      }

                      widget.myListingCubit.applyInsightFilter(selectedCategory);
                      AppRouter.pop(res: AppConstants.applyStr);
                    },
                    title: AppConstants.applyStr,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void resetFilters() {
    _resetTapped = true; // just set the flag
    selectedCategory = null;
    selected = null;
    startDate = null;
    endDate = null;
    setState(() {});
  }
}
