import 'dart:developer';

import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/data/storage/storage.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/add_listing/cubit/add_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/view/add_listing_form_view.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/view/basic_details_view.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

///
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/09/24
/// @Message : [AddListingView]
///
/// The `AddListingView`  class provides a user interface displaying list of categories
///
/// Responsibilities:
///To add list of ads
class AddListingView extends StatefulWidget {
  const AddListingView({super.key});

  @override
  State<AddListingView> createState() => _AddListingViewState();
}

class _AddListingViewState extends State<AddListingView> {
  AddListingCubit addListingCubit = AddListingCubit();

  @override
  void initState() {
    super.initState();
    addListingCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddListingCubit, AddListingState>(
      bloc: addListingCubit,
      builder: (context, state) {
        if (state is AddListingLoadedState) {
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
                body: _buildCategoryList(state),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator()); // Loading state
      },
    );
  }

  /// List of categories with icons
  Widget _buildCategoryList(AddListingLoadedState state) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 12.0,
        right: 12.0,
      ),
      itemCount: state.listings?.length,
      itemBuilder: (context, index) {
        // if (state.listings?.isNotEmpty ?? false) {
        CategoriesListResponse? category = state.listings?[index];
        return _buildCategoryItem(category: category, state: state);
        // }
        // return const SizedBox.shrink();
      },
    );
  }

  /// Each category item
  Widget _buildCategoryItem({required CategoriesListResponse? category, required AddListingLoadedState state}) {
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
              child: ReusableWidgets.createSvg(
                size: 25,
                path: category?.getCategoryIcon() ?? '',
                color: AppColors.whiteColor,
              ),
            ),
          ),
          onTap: () async {
            var user = await PreferenceHelper.instance.getUserData();
            log('user:${user.toJson()}');
            if ((category?.formName == AddListingFormConstants.business ||
                    category?.formName == AddListingFormConstants.promo) &&
                user.result?.accountTypeValue == AppConstants.personalStr) {
              // AppUtils.showSnackBar(AppConstants.noAccessibleStr, SnackBarType.alert, context);
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
            } else {
              if (category?.formName == AddListingFormConstants.job) {
                ReusableWidgets.showAlertDialog(
                  AppConstants.lookingForWorkStr,
                  option1: AppConstants.lookingToWorkStr,
                  option2: AppConstants.lookingToHIreStr,
                  funcOption1: () {
                    CategoriesListResponse? categoryObjc = state.listings!.firstWhere(
                      (category) => category.formName == AddListingFormConstants.worker,
                    );
                    navigatorKey.currentState?.pop(); // Close the loading dialog
                    AppRouter.push(
                      AppRoutes.addListingFormView,
                      args: AddListingFormView(category: categoryObjc, accountType: state.accountType ?? ''),
                    );
                  },
                  funcOption2: () {
                    navigatorKey.currentState?.pop(); // Close the loading dialog
                    AppRouter.push(
                      AppRoutes.addListingFormView,
                      args: AddListingFormView(
                        category: category,
                        accountType: user.result?.accountTypeValue,
                      ),
                    );
                  },
                );
              } else if (category?.formName == AddListingFormConstants.worker) {
                ReusableWidgets.showAlertDialog(
                  AppConstants.lookingForWorkStr,
                  option1: AppConstants.lookingToWorkStr,
                  option2: AppConstants.lookingToHIreStr,
                  funcOption1: () {
                    navigatorKey.currentState?.pop(); // Close the loading dialog
                    AppRouter.push(
                      AppRoutes.addListingFormView,
                      args: AddListingFormView(category: category, accountType: user.result?.accountTypeValue),
                    );
                  },
                  funcOption2: () {
                    CategoriesListResponse? categoryObjc = state.listings!.firstWhere(
                      (category) => category.formName == AddListingFormConstants.job,
                    );
                    navigatorKey.currentState?.pop(); // Close the loading dialog
                    AppRouter.push(
                      AppRoutes.addListingFormView,
                      args: AddListingFormView(category: categoryObjc, accountType: user.result?.accountTypeValue),
                    );
                  },
                );
              } else {
                AppRouter.push(
                  AppRoutes.addListingFormView,
                  args: AddListingFormView(category: category, accountType: user.result?.accountTypeValue),
                );
              }
            }
          }),
    );
  }
}
