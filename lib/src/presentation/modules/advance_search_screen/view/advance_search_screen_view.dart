import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/view/advance_tab_view.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/view/recent_tab_view.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/view/saved_search_tab_view.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/style/style.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03/09/24
/// @Message : [AdvanceSearchScreen]
///
/// The `AdvanceSearchScreen`  class provides a user interface for performing advanced searches,
/// viewing saved searches, and accessing recent searches in the app.
///
/// Responsibilities:
/// - Display a tabbed interface with three sections: Advance Search, Search Screen, and Recent Screen.

class AdvanceSearchScreen extends StatefulWidget {
  final List<CategoriesListResponse>? categoriesList;
  final TextEditingController? locationController;
  final TextEditingController? keywordController;
  final Map<String, dynamic>? oldFormData;

  const AdvanceSearchScreen({
    super.key,
    required this.categoriesList,
    required this.locationController,
    required this.keywordController,
    this.oldFormData,
  });

  @override
  State<AdvanceSearchScreen> createState() => _AdvanceSearchScreenState();
}

class _AdvanceSearchScreenState extends State<AdvanceSearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  AdvanceSearchCubit advanceSearchCubit = AdvanceSearchCubit();

  // Define boolean variable to check selected listing is empty or not for delete
  bool? isListEmpty = false;

  @override
  void initState() {
    super.initState();
    advanceSearchCubit.init();
    advanceSearchCubit.categoriesList = widget.categoriesList;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvanceSearchCubit, AdvanceSearchState>(
      bloc: advanceSearchCubit,
      builder: (context, state) {
        if (state is AdvanceSearchLoadedState) {
          bool? canDelete = state.isEnableDeleteUI;
          if (advanceSearchCubit.isSaved) {
            isListEmpty = advanceSearchCubit.savedSearchListing?.where((item) => item.isChecked == true).isNotEmpty;
          } else {
            isListEmpty = advanceSearchCubit.recentSearchListing?.where((item) => item.isChecked == true).isNotEmpty;
          }
          return Container(
            color: AppColors.primaryColor,
            child: SafeArea(
              bottom: false,
              child: Scaffold(
                appBar: MyAppBar(
                  title: AppConstants.advanceSearchStr,
                  centerTitle: advanceSearchCubit.isAdvanceSearchTab ? true : false,
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.borderColor,
                  rightIconCallback: (isCancel) {
                    if (isCancel) {
                      canDelete = true;
                      advanceSearchCubit.unselectAllItems();
                    } else {
                      canDelete = false;
                      advanceSearchCubit.enableDeleteItemUI();
                    }
                  },
                  isVisibleDeleteText: !advanceSearchCubit.isAdvanceSearchTab,
                  isCancel: canDelete ?? false,
                ),
                body: Stack(
                  children: [
                    _mobileView(state, canDelete),
                    state.isLoading ? const LoaderView():const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _mobileView(AdvanceSearchLoadedState state, bool? canDelete) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _tabButton(0, AssetPath.filterIcon, AppConstants.advanceSearchStr, state),
                const SizedBox(width: 10),
                _tabButton(1, AssetPath.folderIcon, AppConstants.searchScreenStr, state),
                const SizedBox(width: 10),
                _tabButton(2, AssetPath.timeCircleIcon, AppConstants.recentScreenStr, state),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AdvanceSearchTab(
                    state: state,
                    advanceSearchCubit: advanceSearchCubit,
                    locationController: widget.locationController,
                    keywordController: widget.keywordController,
                    oldFormData: widget.oldFormData,
                  ),
                  SavedSearchScreenTab(state: state, advanceSearchCubit: advanceSearchCubit),
                  RecentSearchTab(state: state, advanceSearchCubit: advanceSearchCubit),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 10),
          Visibility(
            visible: !advanceSearchCubit.isAdvanceSearchTab,
            child: Row(
              mainAxisSize: MainAxisSize.max, // Ensure the Row uses the maximum width
              children: [
                Expanded(
                  // Makes the Container take up the full width
                  child: Card(
                    elevation: 20,
                    child: Container(
                      height: 1, // Specify height to make the Container visible
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max, // Ensure the Row uses the maximum width
            children: [
              Visibility(
                visible: state.isEnableDeleteUI != null ? state.isEnableDeleteUI! : false,
                child: Expanded(
                  // Makes the Container take up the full width
                  child: Container(color: AppColors.whiteColor, height: 20),
                ),
              ),
            ],
          ),
          Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Visibility(
                    visible: state.isEnableDeleteUI != null ? state.isEnableDeleteUI! : false,
                    child: Expanded(
                      child: AppButton(
                        function: () {
                          advanceSearchCubit.deleteAll();
                        },
                        bgColor: AppColors.whiteColor,
                        borderColor: AppColors.deleteColor,
                        title: AppConstants.deleteAllStr.toUpperCase(),
                        textStyle: FontTypography.planTxtStyle.copyWith(color: AppColors.deleteColor),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: state.isEnableDeleteUI != null ? state.isEnableDeleteUI! : false,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Opacity(
                          opacity: isListEmpty == true ? 1 : 0.5,
                          child: AppButton(
                            function: () {
                              if (canDelete == true && isListEmpty!=false) {
                                advanceSearchCubit.delete();
                              }
                              else{
                                AppUtils.showSnackBar(AppConstants.noRecord, SnackBarType.alert);
                              }
                            },
                            title: AppConstants.deleteStr.toUpperCase(),
                            textStyle: FontTypography.planTxtStyle.copyWith(color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Renders a tab button with an icon and label. Changes color based on whether it's selected.
  /// Tapping the button switches the active tab using `selectTab`.
  Widget _tabButton(int index, String iconPath, String label, AdvanceSearchLoadedState state) {
    bool isSelected = state.selectedIndex == index;
    bool isDisabled = !advanceSearchCubit.areTabsEnabled && (index == 1 || index == 2);

    return Expanded(
      child: InkWell(
        onTap: isDisabled
            ? null
            : () {
                advanceSearchCubit.isUserLoggedIn().then((isLogged) {
                  if (isLogged == false && index > 0) {
                    ReusableWidgets.showConfirmationWithTwoFuncDialog(
                        AppConstants.appTitleStr, AppConstants.signInAlertStr,
                        option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                      navigatorKey.currentState?.pop();
                      AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                    }, funcNo: () {
                      navigatorKey.currentState?.pop();
                    });
                    return;
                  } else {
                    if (state.isLoading == false) {
                      advanceSearchCubit.manageButtonVisibility(index);
                      advanceSearchCubit.selectTab(index);
                      _pageController.jumpToPage(index);
                    }
                  }
                });
              },
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isDisabled
                ? AppColors.greyUnselectedColor
                : isSelected
                    ? AppColors.primaryColor
                    : AppColors.extraExtraLightColor,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                child: ReusableWidgets.createSvg(
                  size: 16,
                  path: iconPath,
                  color: isDisabled
                      ? AppColors.whiteColor
                      : isSelected
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  style: isDisabled
                      ? FontTypography.defaultTextStyle.copyWith(color: AppColors.whiteColor)
                      : isSelected
                          ? FontTypography.defaultTextStyle.copyWith(color: AppColors.whiteColor)
                          : FontTypography.defaultTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
