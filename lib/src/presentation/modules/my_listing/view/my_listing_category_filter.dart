import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 30-01-2024
/// @Message : [MyListingCategoryFilter]
///
class MyListingCategoryFilter extends StatefulWidget {
  final MyListingCubit myListingCubit;
  final MyListingLoadedState myListingLoadedState;

  const MyListingCategoryFilter({
    super.key,
    required this.myListingCubit,
    required this.myListingLoadedState,
  });

  @override
  State<MyListingCategoryFilter> createState() => _MyListingCategoryFilterState();
}

class _MyListingCategoryFilterState extends State<MyListingCategoryFilter> {
  CommonDropdownModel? selectedItem;
  List<CommonDropdownModel>? dropDownList;

  @override
  void initState() {
    updateSelectedItem();
    super.initState();
  }

  updateSelectedItem() {
    if (widget.myListingCubit.commonDropdownModel != null) {
      selectedItem = widget.myListingCubit.commonDropdownModel!;
    } else {
      selectedItem = CommonDropdownModel(id: 0, name: 'All');
      widget.myListingCubit.commonDropdownModel = selectedItem;
    }

    // Generate the dropdown items list
    dropDownList = widget.myListingCubit.dropDownList
            ?.map((item) => CommonDropdownModel(id: item.formId ?? 0, name: item.formName ?? ''))
            .toList() ??
        [];
    // Add the default "All" option at the first position
    dropDownList?.insert(0, CommonDropdownModel(id: 0, name: 'All'));
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
                const SizedBox(width: 50),
                Expanded(
                  flex: 6,
                  child: Text(
                    AppConstants.filterMyListingsStr,
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
                      style: selectedItem != null
                          ? FontTypography.planTxtStyle
                          : FontTypography.planTxtStyle.copyWith(color: AppColors.hintStyle),
                    ),
                  ),
                )
              ],
            ),
            LabelText(
              title: AppConstants.selectCategoryStr,
              isRequired: false,
              textStyle: FontTypography.advanceScreenSortByStyle,
            ),
            DropDownWidget2(
              hintText: AppConstants.businessStr,
              items: dropDownList,
              dropDownValue: selectedItem,
              dropDownOnChange: (CommonDropdownModel? value) {
                setState(() {
                  selectedItem = value;
                });
              },
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
                      widget.myListingCubit.applyCategoryFilter(selectedItem);
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
    widget.myListingCubit.commonDropdownModel = null;
    updateSelectedItem();
    setState(() {});
  }
}
