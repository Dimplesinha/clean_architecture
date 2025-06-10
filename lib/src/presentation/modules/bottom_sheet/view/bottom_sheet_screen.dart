import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/dashboard/bloc/dashboard_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/09/24
/// @Message : [BottomSheetScreen]
///
/// The `BottomSheetScreen`  class provides a user interface to select location and category filter
class BottomSheetScreen extends StatefulWidget {
  final DashboardCubit dashboardCubit;
  final Function() callBackOnTap;
  final bool isFromCategory;

  const BottomSheetScreen({
    super.key,
    required this.dashboardCubit,
    required this.callBackOnTap,
    required this.isFromCategory,
  });

  @override
  State<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  @override
  void initState() {
    super.initState();
    // widget.dashboardCubit.fetchAllCategories();
  }

  String selectedSingleOptions = '';
  String selectedPath = '';
  List<String> selectedOptions = [];
  List<CategoriesListResponse> categoryData = [];
  List<CategoriesListResponse> selectedCategoryData = [];

  @override
  Widget build(BuildContext context) {
    // Assuming you have your AppColors, FontTypography, AppConstants, AssetPath, AppButton, sizedBox20Height, DashboardCubit, DashboardState, DashboardLoadedState, and your category data model defined.
    return BlocBuilder<DashboardCubit, DashboardState>(
      bloc: widget.dashboardCubit,
      builder: (context, state) {
        if (state is DashboardLoadedState) {
          // Extracting selected options and categories from state
          selectedOptions = state.selectedOptions ?? [];
          selectedSingleOptions = state.tempSelectedSingleOption ?? '';
          selectedPath = state.tempPath ?? '';
          selectedCategoryData = state.selectedTempListings ?? [];
          categoryData = state.listings ?? [];
          bool isSelectAllSelected = selectedCategoryData.length == categoryData.length;
          widget.dashboardCubit.isAllCategorySelected = isSelectAllSelected ;
          return Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Important for proper sizing
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 7,
                  width: 59,
                  decoration: BoxDecoration(
                    color: AppColors.bottomSheetBarColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.isFromCategory
                      ? AppConstants.lookingForCategoriesStr
                      : AppConstants.lookingForLocationStr,
                  style: FontTypography.bottomSheetHeading,
                ),
                Flexible(
                  // Use expanded for the scrollable part.
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 10), // Reduced bottom padding here
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 5),
                          // Show location buttons if not from category
                          Visibility(
                            visible: !widget.isFromCategory,
                            child: Wrap(
                              spacing: 7.0,
                              runSpacing: 20.0,
                              children: [
                                _buildOptionsButton(
                                  path: AssetPath.nearMeIcon,
                                  label: AppConstants.nearMeStr,
                                  onTap: () {
                                    widget.dashboardCubit
                                        .selectSingleOption(AppConstants.nearMeStr, AssetPath.nearMeIcon);
                                    //widget.callBackOnTap();
                                  },
                                  isSelected: selectedSingleOptions == AppConstants.nearMeStr,
                                ),
                                _buildOptionsButton(
                                  path: AssetPath.myCountryIcon,
                                  label: AppConstants.myCountryStr,
                                  onTap: () {
                                    widget.dashboardCubit
                                        .selectSingleOption(AppConstants.myCountryStr, AssetPath.myCountryIcon);
                                    //widget.callBackOnTap();
                                  },
                                  isSelected: selectedSingleOptions == AppConstants.myCountryStr,
                                ),
                                _buildOptionsButton(
                                  path: AssetPath.worldWideIcon,
                                  label: AppConstants.worldwideStr,
                                  onTap: () {
                                    widget.dashboardCubit
                                        .selectSingleOption(AppConstants.worldwideStr, AssetPath.worldWideIcon);
                                    //widget.callBackOnTap();
                                  },
                                  isSelected: selectedSingleOptions == AppConstants.worldwideStr,
                                ),
                              ],
                            ),
                          ),
                          // Show category buttons if from category
                          Visibility(
                            visible: widget.isFromCategory,
                            child: Flexible(
                              child: Wrap(
                                spacing: 15.0,
                                runSpacing: 15.0,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                children: [
                                  // "All" option
                                  _buildOptionsButton(
                                    path: AssetPath.allCategoryIcon,
                                    label: AppConstants.allStr,
                                    onTap: () {
                                      if (isSelectAllSelected) {
                                        return;
                                      }
                                      isSelectAllSelected = true;
                                      widget.dashboardCubit.selectAllCategories();
                                      //widget.callBackOnTap();
                                    },
                                    isSelected: isSelectAllSelected,
                                  ),
                                  // Category list
                                  ...categoryData.map((category) {
                                    return _buildOptionsButton(
                                      path: category.getCategoryIcon(),
                                      label: category.formName ?? '',
                                      onTap: () async {
                                        widget.dashboardCubit.selectCategory(category);
                                      },
                                      isSelected: selectedCategoryData.contains(category),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                          sizedBox20Height(),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 25), // Increased bottom padding for buttons
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          function: () {
                            if (widget.isFromCategory) {
                              widget.dashboardCubit.setInitialCategory();
                            } else {
                              widget.dashboardCubit.setInitialSelectedOption(state.selectedSingleOption, state.path);
                            }
                            Navigator.of(context).pop();
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
                            if (widget.isFromCategory) {
                              widget.dashboardCubit.setActualCategory();
                            } else {
                              widget.dashboardCubit
                                  .setActualSelectedOption(state.tempSelectedSingleOption, state.tempPath);
                            }
                            widget.callBackOnTap();
                            Navigator.of(context).pop();
                          },
                          title: AppConstants.okStr,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  // Helper method to build location buttons with icons and labels
  Widget _buildOptionsButton({
    required String path,
    required String label,
    required Function() onTap,
    required bool isSelected,
  }) {
    return SizedBox(
      height: 41,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: ReusableWidgets.createSvg(
          path: path,
          color: isSelected ? AppColors.primaryColor : AppColors.jetBlackColor,
        ),
        label: Text(
          label,
          maxLines: 1,
          style: isSelected
              ? FontTypography.bottomSheetGreyTextStyle.copyWith(color: AppColors.primaryColor)
              : FontTypography.bottomSheetGreyTextStyle,
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          backgroundColor: isSelected ? AppColors.transparentSecondaryColor : AppColors.locationButtonBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
              )),
          elevation: 0,
        ),
      ),
    );
  }
}
