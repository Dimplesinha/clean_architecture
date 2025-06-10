import 'dart:developer';

import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/data/storage/storage.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_category.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/view/add_listing_form_view.dart';
import 'package:workapp/src/presentation/modules/dynamic_add_listing/cubit/dynamic_add_lisiting_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/view/basic_details_view.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

///
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 05/03/25
/// @Message : [DynamicAddListingView]
///
/// The `DynamicAddListingView`  class provides a user interface displaying list of categories
///
/// Responsibilities:
///To add list of ads
class DynamicAddListingView extends StatefulWidget {
  const DynamicAddListingView({super.key});

  @override
  State<DynamicAddListingView> createState() => _DynamicAddListingViewState();
}

class _DynamicAddListingViewState extends State<DynamicAddListingView> {
  DynamicAddListingCubit dynamicAddListingCubit = DynamicAddListingCubit();

  @override
  void initState() {
    super.initState();
    dynamicAddListingCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DynamicAddListingCubit, DynamicAddListingState>(
      bloc: dynamicAddListingCubit,
      builder: (context, state) {
        if (state is DynamicAddListingLoadedState) {
          return Container(
            color: AppColors.primaryColor,
            child: SafeArea(
              bottom: false,
              child: Scaffold(
                backgroundColor: AppColors.whiteColor,
                appBar: AppBar(
                  backgroundColor: AppColors.whiteColor,
                  elevation: 2,
                  surfaceTintColor: AppColors.whiteColor,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: InkWell(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.categoryIconBgColor,
                        child: ReusableWidgets.createSvg(path: AssetPath.categorySvgIcon),
                      ),
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    AppConstants.addListingStr,
                    style: FontTypography.appBarStyle,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                          icon: ReusableWidgets.createSvg(
                              path: AssetPath.searchIconSvg, // Add the path to your custom SVG search icon
                              size: 22, // Adjust the size if needed
                              color: AppColors.blackColor),
                          // onPressed: () => AppRouter.push(AppRoutes.searchScreenRoute),
                          onPressed: () async {
                            var categoryData = await PreferenceHelper.instance.getCategoryList();
                            var categoriesList = categoryData.result;
                            AppRouter.push(AppRoutes.searchScreenRoute,
                                args: {ModelKeys.categoriesList: categoriesList});
                          }),
                    )
                  ],
                ),
                body: Stack(
                  children: [_buildCategoryList(state), state.isLoading ? const LoaderView() : const SizedBox.shrink()],
                ),
              ),
            ),
          );
        }
        return const LoaderView(); // Loading state
      },
    );
  }

  /// List of categories with icons
  Widget _buildCategoryList(DynamicAddListingLoadedState state) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
      itemCount: state.listings?.length,
      itemBuilder: (context, index) {
        CategoriesListResponse? category = state.listings?[index];

        return _buildCategoryItem(category: category, state: state);
      },
    );
  }

  /// Each category item
  Widget _buildCategoryItem({required CategoriesListResponse? category, required DynamicAddListingLoadedState state}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.profileTileBgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20),
          title: Text(category?.formName ?? '', style: FontTypography.profileTitleString),
          trailing: Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(80), // Left side rounded
                right: Radius.circular(0), // Right side straight
              ),
            ),
            child: Center(
              child: ReusableWidgets.createNetworkSvg(
                size: 25,
                path: category?.iconUrl ?? '',
                color: AppColors.whiteColor,
              ),
            ),
          ),
          onTap: () async {
            var user = await PreferenceHelper.instance.getUserData();
            log('user:${user.toJson()}');
            if (user.result?.accountType == int.parse(AccountType.personal.value) &&
                (category?.accountType != null && category!.accountType!.split(',').contains(AccountType.business.value) &&
                    !category.accountType!.split(',').contains(AccountType.personal.value))) {

              ReusableWidgets.showConfirmationWithTwoFuncDialog(AppConstants.appTitleStr, AppConstants.updatedAccount,
                  option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                AppRouter.push(
                  AppRoutes.profileBasicDetailsScreenRoute,
                  args: const BasicDetailsScreen(),
                )?.then((result) {
                  navigatorKey.currentState?.pop();
                });
              }, funcNo: () {
                navigatorKey.currentState?.pop(); // Close the loading dialog
              });
            } else if (user.result?.accountType == int.parse(AccountType.business.value) &&
                  (category?.accountType != null && !category!.accountType!.split(',').contains(AccountType.business.value) &&
                    category.accountType!.split(',').contains(AccountType.personal.value))) {
              ReusableWidgets.showConfirmationWithTwoFuncDialog(AppConstants.appTitleStr, AppConstants.updatedAccountPersonal,
                  option1: AppConstants.yesStr, option2: AppConstants.noStr, funcYes: () {
                    AppRouter.push(
                      AppRoutes.profileBasicDetailsScreenRoute,
                      args: const BasicDetailsScreen(),
                    )?.then((result) {
                      navigatorKey.currentState?.pop();
                    });
                  }, funcNo: () {
                    navigatorKey.currentState?.pop(); // Close the loading dialog
                  });
            } else {
              AppRouter.push(
                AppRoutes.addListingFormView,
                args: AddListingFormView(
                  formId: category?.formId ?? 0,
                  category: category,
                ),
              );
            }
          }),
    );
  }
}
