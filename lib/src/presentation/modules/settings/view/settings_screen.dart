import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/settings/cubit/settings_cubit.dart';
import 'package:workapp/src/presentation/modules/settings/cubit/settings_state.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/presentation/widgets/social_btn.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/12/24
/// @Message : [SettingScreen]
///
/// The `SettingScreen` class provides a user interface for configuring user account settings.
/// It allows users to link their LinkedIn, Google, and Apple accounts for seamless sign-in.
///
/// Responsibilities:
/// - Display linking options for LinkedIn, Google, and Apple accounts.
/// - Provide buttons for each social media platform.
/// - Manage the UI layout and styling of the settings screen.

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int loginType = AppConstants.normalLoginType;

  // SettingsCubit initializing to call in bloc builder and calling cubit methods where need to manage state
  final SettingsCubit _settingsCubit = SettingsCubit();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  String socialMediaUserId = '';

  @override
  void initState() {
    super.initState();
    _settingsCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        builder: (context, state) {
          if (state is SettingsLoadedState) {
            return Stack(
              children: [
                SafeArea(
                  bottom: false,
                  child: Scaffold(
                    body: Container(
                      color: AppColors.primaryColor,
                      child: SafeArea(
                        bottom: false,
                        child: Scaffold(
                          appBar: MyAppBar(
                            title: AppConstants.settingScreenStr,
                            centerTitle: true,
                            automaticallyImplyLeading: false,
                            shadowColor: AppColors.borderColor,
                          ),
                          body: SingleChildScrollView(
                            child: _mobileView(state),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                state.loading ? const LoaderView() : const SizedBox.shrink(),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  /// Builds the UI layout for the settings screen.
  /// Contains sections for linking to LinkedIn, Google, and Apple accounts.
  Widget _mobileView(SettingsLoadedState state) {
    var linkedinUserId = state.loginResponse?.result?.linkdinUserId;
    var googleUserId = state.loginResponse?.result?.googleUserId;
    var appleUserId = state.loginResponse?.result?.appleUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LinkedIn Account Linking Section
          Visibility(
              visible: linkedinUserId != null ? false : true,
              child: LabelText(
                title: AppConstants.linkLinkedInStr,
                isRequired: false,
                textStyle: FontTypography.textFieldBlackStyle,
              )),
          Visibility(
              visible: linkedinUserId != null ? false : true,
              child: SocialMediaButton(
                function: () {
                  linkWithLinkedin();
                }, // Function to handle LinkedIn sign-in
                image: SvgPicture.asset(
                  AssetPath.linkedInBoxIcon,
                  fit: BoxFit.cover,
                ),
                backgroundColor: AppColors.primaryDarkBlueColor,
                label: Text(
                  AppConstants.signInLinkedInStr,
                  style: FontTypography.socialBtnStyle,
                ),
              )),
          Visibility(
            visible: linkedinUserId != null ? false : true,
            child: const SizedBox(height: 20),
          ),
          Visibility(
            visible: googleUserId != null ? false : true,
            child: const Divider(height: 0),
          ),
          // Google Account Linking Section
          Visibility(
            visible: googleUserId != null ? false : true,
            child: LabelText(
              title: AppConstants.linkGoogleStr,
              isRequired: false,
              textStyle: FontTypography.textFieldBlackStyle,
            ),
          ),
          Visibility(
            visible: googleUserId != null ? false : true,
            child: SocialMediaButton(
              function: () {
                linkGoogleSignUp();
              }, // Function to handle Google sign-in
              image: SvgPicture.asset(AssetPath.googleOriginalIcon, fit: BoxFit.cover),
              backgroundColor: AppColors.whiteColor,
              label: Text(
                AppConstants.signInGoogleStr,
                style: FontTypography.socialBtnStyle.copyWith(color: AppColors.blackColor),
              ),
            ),
          ),
          Visibility(
            visible: googleUserId != null ? false : true,
            child: const SizedBox(height: 20),
          ),
          Visibility(
            visible: appleUserId == null || appleUserId.isEmpty
                ? Platform.isIOS
                    ? true
                    : false
                : false,
            child: const Divider(height: 0),
          ),
          // Apple Account Linking Section
          Visibility(
            visible: appleUserId == null || appleUserId.isEmpty
                ? Platform.isIOS
                    ? true
                    : false
                : false,
            child: LabelText(
              title: AppConstants.linkAppleStr,
              isRequired: false,
              textStyle: FontTypography.textFieldBlackStyle,
            ),
          ),
          Visibility(
            visible: appleUserId == null || appleUserId.isEmpty
                ? Platform.isIOS
                    ? true
                    : false
                : false,
            child: SocialMediaButton(
              function: () {
                linkWithApple();
              }, // Function to handle Apple sign-in
              image: SvgPicture.asset(
                AssetPath.appleWhiteIcon,
                fit: BoxFit.cover,
              ),
              backgroundColor: AppColors.jetBlackColor,
              label: Text(
                AppConstants.signInAppleStr,
                style: FontTypography.socialBtnStyle.copyWith(color: AppColors.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// handle apple link
  Future<void> linkWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken != null) {
        String firstName = '';
        String lastName = '';
        String? displayName = credential.givenName;
        // Split display name into first and last names
        if (displayName != null) {
          List<String> nameParts = displayName.split(' ');
          firstName = nameParts.isNotEmpty ? nameParts.first : '';
          lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        }
        if (credential.identityToken != null) {
          // Proceed with the login process
          _settingsCubit.handleExistingUserLogin(
            navigatorKey.currentContext ?? context,
            firstName: firstName,
            lastName: lastName,
            email: credential.email ?? '',
            password: '',
            socialMediaType: AppConstants.appleLoginType,
            socialMediaUserID: credential.userIdentifier ?? '',
            profilePic: '',
          );
        }
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      AppUtils.showErrorSnackBar(e.message);
      if (kDebugMode) print('_SignInScreenState._appleAuth $e');
    } catch (e) {
      AppUtils.showErrorSnackBar(e.toString());
      if (kDebugMode) print('_SignInScreenState._appleAuth $e');
    }
  }

  /// handle google signup
  Future<void> linkGoogleSignUp() async {
    try {
      if (kIsWeb || Platform.isAndroid) {
        _googleSignIn = GoogleSignIn(
          scopes: [
            'email',
          ],
        );
      }

      if (Platform.isIOS || Platform.isMacOS) {
        _googleSignIn = GoogleSignIn(
          clientId: '79938276897-ct8d57r73obfj3kk6ggnvi7divv7v8e1.apps.googleusercontent.com',
          scopes: [
            'email',
          ],
        );
      }
      // Sign out to force showing the account picker if a user is already signed in.
      await _googleSignIn.signOut();

      // Attempt to sign in, showing the account picker.
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      // If no account is selected, account will be null, so we can return early.
      if (account == null) {
        return;
      }

      String email = account.email;
      socialMediaUserId = account.id;
      loginType = AppConstants.googleLoginType;
      String displayName = account.displayName ?? '';
      String? firstName = '';
      String? lastName = '';
      String? profilePic = account.photoUrl;

      if (displayName.isNotEmpty) {
        List<String> nameParts = displayName.split(' ');
        firstName = nameParts.isNotEmpty ? nameParts.first : '';
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }

      await _settingsCubit.handleExistingUserLogin(
        context,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: '',
        socialMediaType: loginType,
        // 1 is for normal login with email id and password
        socialMediaUserID: socialMediaUserId,
        profilePic: profilePic ?? '',
      );
    } catch (e) {
      // Handle any errors that may occur during Google Sign-in.
      if (kDebugMode) {
        print('Google Sign-in error: ${e.toString()}');
      }
    }
  }

  /// handle linkedIn signup
  Future<void> linkWithLinkedin() async {
    navigatorKey.currentState?.pushNamed(AppRoutes.linkedinLoginView).then((result) {
      try {
        // Check if result is of the expected type
        if (result is Map<String, dynamic>) {
          loginType = AppConstants.linkedInLoginType;
          String? socialMediaUserId = result[ModelKeys.socialMediaUserId];
          var firstName = result[ModelKeys.firstName];
          var lastName = result[ModelKeys.lastName];
          var email = result[ModelKeys.email];
          String profilePic = result[ModelKeys.profilePic];
          // Check that all required fields are not null
          if (socialMediaUserId != null) {
              // Proceed with the login process
            _settingsCubit.handleExistingUserLogin(
              context,
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: '',
              socialMediaType: loginType,
              socialMediaUserID: socialMediaUserId,
              profilePic: profilePic,
            );
          }
        } else {
          // Handle if result is not of the expected type
          throw Exception('Invalid result type: Expected a Map.');
        }
      } catch (e) {
        // Handle any errors that may occur
        if (kDebugMode) {
          print('Error during LinkedIn sign-in: $e');
        }
      }
    });
  }
}
