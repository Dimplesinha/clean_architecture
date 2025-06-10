import 'dart:io';

import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/repositories/auth_repo.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/view/add_switch_account_view.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/signalr_helper.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 05/09/24
/// @Message : [MyDrawer]
///

/// The `MyDrawer` class is a customizable navigation drawer for the application.
/// This drawer provides quick access to various sections of the app such as the user profile, settings,
/// privacy policies, feedback, and more.
/// It also allows users to log out or delete their account.
///
/// The drawer is displayed when the user swipes from the edge of the screen or taps on the menu icon.
/// It contains a user account section that displays the user's avatar and name, as well as various navigational options
/// represented as list tiles with corresponding icons.
///
/// Responsibilities:
/// - Displays the user's account details (avatar and name).
/// - Provides navigation to various app sections like Profile, Settings, and Feedback.
/// - Includes an option to log out or delete the user’s account.
/// - Each list item triggers a corresponding action when tapped, such as navigating to another page or opening dialogs for logout or confirmation.
/// - Provides a button in the user account section for an additional feature (represented by the diamond icon in the trailing position).
///
/// Key functionalities:
/// - `_userAccount()`: Displays the user account section at the top of the drawer with the avatar, name, and a customizable button.
/// - `_drawerItem()`: A reusable function that builds list tiles for each navigational item in the drawer, including its icon and title.
/// - `logoutClick()`: Handles the logout process by showing a confirmation dialog and performing the necessary actions to log out the user, including API calls.

class MyDrawer extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String profilePic;
  final bool isPasswordAvailable;

  const MyDrawer(
      {Key? key,
      required this.firstName,
      required this.profilePic,
      required this.isPasswordAvailable,
      required this.lastName})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  LoginModel? loggedInUserData;
  bool isPasswordAvailable = false;
  bool isNeedToShowSettings = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _loadUserData();
      });
    });
    super.initState();
  }

  Future<void> _loadUserData() async {
    PreferenceHelper preferenceHelper = PreferenceHelper.instance;
    LoginResponse userData = await preferenceHelper.getUserData();
    isPasswordAvailable = userData.result?.isPasswordAvailable ?? false;
    loggedInUserData = userData.result;
    if (Platform.isAndroid) {
      isNeedToShowSettings =
          userData.result?.linkdinUserId != null && userData.result?.googleUserId != null ? false : true;
    } else if (Platform.isIOS) {
      isNeedToShowSettings = userData.result?.linkdinUserId != null &&
              userData.result?.googleUserId != null &&
              userData.result?.appleUserId != null
          ? false
          : true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isPasswordAvailable = AppUtils.loginUserModel?.isPasswordAvailable ?? false;
    return Drawer(
      backgroundColor: AppColors.whiteColor,
      width: 240,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero, // No padding for the list items
          children: [
            _userAccount(), // Displays the user account section
            const SizedBox(height: 12.0), // Adds space between account and items
            _divider(), // A divider separating the user account from the list items
            // List of navigational items in the drawer
            _drawerItem(AppConstants.myAccountStr, AssetPath.myProfileIcon, context),
            _drawerItem(isPasswordAvailable ? AppConstants.changePasswordStr : AppConstants.setPasswordStr,
                AssetPath.changePasswordIcon, context),
            isNeedToShowSettings == true
                ? _drawerItem(AppConstants.settingsStr, AssetPath.settingsIcon, context)
                : const SizedBox(),
            _drawerItem(AppConstants.shareStr, AssetPath.shareIcon, context),
            _drawerItem(AppConstants.contactUs, AssetPath.contactUsIcon, context),
            _drawerItem(AppConstants.rateUsStr, AssetPath.rateUsIcon, context),
            _drawerItem(AppConstants.aboutUsStr, AssetPath.aboutUsIcon, context),
            _drawerItem(AppConstants.termOfUseStr, AssetPath.termOfUseIcon, context),
            _drawerItem(AppConstants.privacyPolicyStr, AssetPath.privacyPolicyIcon, context),
            _drawerItem(AppConstants.faqStr, AssetPath.privacyPolicyIcon, context),

            ///ToDo: Ask for faq icon
            _drawerItem(AppConstants.logoutStr, AssetPath.logoutIcon, context),
            _drawerItem(AppConstants.deleteAccountStr, AssetPath.deleteAccountIcon, context),
          ],
        ),
      ),
    );
  }

  /// Creates a divider with specific thickness to separate sections
  Widget _divider() {
    return const Divider(thickness: 0.3, height: 0);
  }

  /// Builds a drawer item (ListTile) with an icon, title, and onTap functionality.
  /// [fun]: The function that gets called when the item is tapped.
  /// [title]: The title of the drawer item.
  /// [iconPath]: The path to the icon image.
  Widget _drawerItem(String title, String iconPath, BuildContext context) => ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: ReusableWidgets.createSvg(path: iconPath, size: 22),
        ), // Icon on the left
        title: Text(
          title,
          style: FontTypography.subTextStyle.copyWith(
            color: title == AppConstants.logoutStr
                ? AppColors.errorColor // Red color for the logout item
                : AppColors.jetBlackColor, // Default black color for others
          ),
        ),
        onTap: () {
          AppRouter.pop();
          _handleDrawerNavigation(title, context);
        }, // Executes the function when tapped
      );

  /// Builds the user account section that displays the avatar and name.
  /// The trailing button can be customized for any feature (currently set to diamond icon).
  Widget _userAccount() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 20, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        AppRouter.pop();
                        _handleDrawerNavigation(AppConstants.myAccountStr, context);},
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: LoadProfileImage(url: loggedInUserData?.profilepic),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    AppRouter.pop();
                                    _handleDrawerNavigation(AppConstants.myAccountStr, context);
                                  },
                                  child: Text(
                                    '${loggedInUserData?.firstName ?? ' '} ${loggedInUserData?.lastName}',
                                    style: FontTypography.profileTitleString,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: AppUtils.loginUserModel?.subscriberPlan != null || AppUtils.loginUserModel?.planPurchased==true,
                                child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, // White background for the button
                                      padding: const EdgeInsets.symmetric(vertical: 4), // Button padding
                                      elevation: 3, // Elevation for shadow effect
                                    ),
                                    onPressed: () {}, // Action for the button (currently empty)
                                    child: ReusableWidgets.createSvg(
                                        size: 20, path: AssetPath.diamondIcon), // Icon inside the button
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                        InkWell(
                            onTap: () {
                              AppRouter.pop();
                              _handleDrawerNavigation(AppConstants.myAccountStr, context);},
                            child: Text(
                              loggedInUserData?.email ?? '',
                              style: FontTypography.locationTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          sizedBox5Height(),
                          InkWell(
                            onTap: () {
                              /// For Closing the drawer
                              navigatorKey.currentState?.pop();

                              /// Handling the bottomSheet for Adding or switching account
                              _handleAddOrSwitchAccount();
                            },
                            child: Text(
                              AppConstants.addOrSwitchAccount,
                              style: FontTypography.addAccountStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Handles navigation of each title we have in drawer
  _handleDrawerNavigation(String title, BuildContext context) {
    String route = '';
    dynamic args;
    switch (title) {
      case AppConstants.myAccountStr:
        route = AppRoutes.myProfileScreenRoute;
        args = {
          ModelKeys.isFromProfile: true,
        };
        break;
      case AppConstants.changePasswordStr:
        route = AppRoutes.changePasswordRoute;
        break;
      case AppConstants.setPasswordStr:
        route = AppRoutes.changePasswordRoute;
        break;
      case AppConstants.settingsStr:
        route = AppRoutes.settingScreenRoute;
        break;
      case AppConstants.contactUs:
        route = AppRoutes.contactUsRoute;
        break;
      case AppConstants.shareStr:
        shareWorkApp(context);
        break;
      case AppConstants.termOfUseStr:
        route = AppRoutes.termsConditionScreen;
        args = {ModelKeys.cmsTypeIdStr: ApiConstant.termConditionsInt};
        break;
      case AppConstants.privacyPolicyStr:
        route = AppRoutes.termsConditionScreen;
        args = {ModelKeys.cmsTypeIdStr: ApiConstant.privacyPolicyInt};
        break;
      case AppConstants.aboutUsStr:
        route = AppRoutes.termsConditionScreen;
        args = {ModelKeys.cmsTypeIdStr: ApiConstant.aboutUsInt};
        break;
      case AppConstants.faqStr:
        route = AppRoutes.faqScreen;
        break;
      case AppConstants.logoutStr:
        logoutClick(message: AppConstants.areYouSureLogoutStr);
        break;
      case AppConstants.deleteAccountStr:
        logoutClick(message: AppConstants.areYouSureDeleteAccStr);
        break;
    }

    if (title != AppConstants.logoutStr) {
      if (title != AppConstants.shareStr) {
        if (title != AppConstants.deleteAccountStr) {
          AppRouter.push(route, args: args);
        }
      }
    }
  }

  void shareWorkApp(BuildContext context) {
    Share.share('Check out this app: ', subject: AppConstants.shareStr);
  }

  /// Handles the logout action. It first shows a confirmation dialog,
  /// then performs the logout if confirmed.
  void logoutClick({required String message}) {
    ReusableWidgets.showConfirmationDialog(
      AppConstants.appTitleStr,
      message,
          () async {
        navigatorKey.currentState?.pop(); // Close confirmation dialog

        ReusableWidgets.showLoaderDialog();

        var response;
        if (message == AppConstants.areYouSureLogoutStr) {
          response = await AuthRepository.instance.logout();
        } else {
          response = await AuthRepository.instance.deleteAccount();
        }

        navigatorKey.currentState?.pop(); // Close loader dialog

        if (response.status) {
          disconnectSignalR();

          // Delay navigation slightly to let the current context finish popping
          Future.delayed(const Duration(milliseconds: 100), () {
            AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
            AppUtils.showSnackBar(response.message, SnackBarType.success);
          });
        } else {
          AppUtils.showSnackBar(response.message, SnackBarType.fail);
        }
      },
    );
  }

  Future<void> disconnectSignalR() async {
    final SignalRHelper signalR = SignalRHelper.instance;
    await signalR.disconnect();
  }

  void _handleAddOrSwitchAccount() {
    AppUtils.showBottomSheet(
      context,
      isDismissible: false,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableWidgets.createBottomSheetBar(),
              const AddSwitchAccountView(),
            ],
          ),
        ),
      ),
    );
  }
}
