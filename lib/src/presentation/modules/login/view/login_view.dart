import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/login/cubit/login_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03-09-2024
/// @Message : [SignInView]

/// The `SignInView` class is the login screen of the application.
/// This view is displayed after splash screen when user has not logged in the app
/// Typically, it shows the email and password text field which are mandatory to sign in the account.
/// It also has option of social media account login such as LinkedIn and
/// also has two option using your device account i.e. Apple account and google account.
///
/// Responsibilities:
/// - Displays other sign in option.
/// - Also has remember me option so that it can store your sign in details so no need to add details again after
/// selecting remember option.
/// - It also contains forget password option in case user forgotten their password.

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  ///LoginCubit for managing state.
  LoginCubit loginCubit = LoginCubit();

  /// Email and Password Text Editing controller used for app text-field for data storing.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String socialMediaUserID = '';
  String firstName = '';
  String lastName = '';
  int loginType = AppConstants.normalLoginType;
  String? email = '';
  String? password = '';
  bool isRememberMe = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  ///Init state for calling all init state method on UI loading and adding cubit to initialize
  @override
  void initState() {
    loginCubit.init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadUserData();
    });
    super.initState();
  }

  Future<void> _loadUserData() async {
    PreferenceHelper preferenceHelper = PreferenceHelper.instance;
    LoginResponse userData = await preferenceHelper.getUserData();
    emailController.text = userData.result?.email ?? emailController.text;
    passwordController.text = userData.result?.password ?? passwordController.text;
    isRememberMe = userData.result?.rememberMeEnabled ?? false;
    if (isRememberMe) {
      loginCubit.onIsRememberMe();
    }
  }

  ///SingleChildScroll view to control scroll which also allows to dismiss keyboard on drag.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<LoginCubit, LoginState>(
        bloc: loginCubit,
        builder: (context, state) {
          if (state is LoginLoadedState) {
            return SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Scaffold(
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          sizedBox20Height(),
                          _logoView(),
                          sizedBox30Height(),
                          _signSubTitleView(),
                          sizedBox20Height(),
                          _emailTxtField(),
                          sizedBox20Height(),
                          _passwordTxtField(state),
                          sizedBox20Height(),
                          _forgotPasswordRememberMeView(state),
                          sizedBox20Height(),
                          _buildSignInBtn(
                            function: () => onSignInPress(state),
                            title: AppConstants.signInStr,
                          ),
                          sizedBox20Height(),
                          _buildSignInBtn(
                              function: () {
                                AppRouter.push(AppRoutes.homeScreenRoute);
                              },
                              bgColor: AppColors.jetBlackColor,
                              title: AppConstants.viewAsGuestStr,
                              elevation: 0),
                          sizedBox20Height(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SvgPicture.asset(AssetPath.orDivider),
                          ),
                          sizedBox20Height(),
                          _socialMediaRow(),
                          sizedBox20Height(),
                          _dontHaveAccount()
                        ],
                      ),
                    ),
                  ),
                  state.loading ? const LoaderView() : const SizedBox.shrink()
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  ///This widget used for signIn sub title view which indicated the screen name and small welcome note.
  Widget _signSubTitleView() {
    return Center(
      child: Column(
        children: [
          Text(
            AppConstants.signInStr,
            style: FontTypography.signInBoldStyle,
          ),
          sizedBox10Height(),
          Text(
            AppConstants.signInSubStr,
            style: FontTypography.subTextStyle,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  /// Email text-field where user has to enter it's registered email address for login
  /// where value is passed in texteditcontroller (i.e. controller).
  /// it uses AppTextField which is custom designed text-field for the app.
  Widget _emailTxtField() {
    return AppTextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      hintTxt: AppConstants.enterEmailHintStr,
      textCapitalization: TextCapitalization.none,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          AssetPath.emailIcon,
          fit: BoxFit.contain,
          height: 8.0,
          width: 8.0,
        ),
      ),
    );
  }

  /// Password text-field where user add there password for signing in which is registered with email address used,
  /// where value is passed in texteditcontroller (i.e. controller).
  /// it uses AppTextField which is custom designed text-field for the app.
  Widget _passwordTxtField(LoginLoadedState state) {
    return AppTextField(
      controller: passwordController,
      obscureText: !state.showPassword,
      maxLines: 1,
      hintTxt: AppConstants.passwordStr,
      textInputAction: TextInputAction.done,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          AssetPath.passwordLockIcon,
          fit: BoxFit.contain,
          height: 10.0,
          width: 10.0,
        ),
      ),
      suffixIcon: InkWell(
        onTap: () => loginCubit.onShowPassword(),
        child: (state.showPassword)
            ? Icon(
                Icons.visibility_outlined,
                size: 15,
                color: AppColors.passwordEyeColor,
              )
            : Icon(
                Icons.visibility_off_outlined,
                color: AppColors.passwordEyeColor,
                size: 15,
              ),
      ),
    );
  }

  ///Forget password is text button from where you can be redirected to forget password screen
  ///Remember Me is checked box where selecting it will allow to set values to preference for direct login
  Widget _forgotPasswordRememberMeView(LoginLoadedState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                checkColor: AppColors.whiteColor,
                side: BorderSide(color: AppColors.primaryColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: BorderSide(color: AppColors.primaryColor),
                ),
                activeColor: AppColors.primaryColor,
                value: state.isChecked,
                onChanged: (value) => loginCubit.onIsRememberMe(),
              ),
            ),
            sizedBox5Width(),
            Text(
              AppConstants.rememberMeStr,
              style: FontTypography.textFieldHintStyle.copyWith(fontSize: 16.0),
            )
          ],
        ),
        GestureDetector(
          onTap: () => AppRouter.push(AppRoutes.forgotPasswordScreenRoute),
          child: Text(AppConstants.forgotPasswordStr, style: FontTypography.forgetPassStyle),
        ),
      ],
    );
  }

  /// AppButton used for sign in option and sign in as guest button where function is managed when in used and title
  /// managed as per need and bgColor to change button color if needed as we can see 2 buttons on screen with
  /// different colors and functions.
  Widget _buildSignInBtn(
      {required dynamic Function() function, Color? bgColor, required String title, double? elevation}) {
    return AppButton(
      bgColor: bgColor,
      function: function,
      title: title,
      elevation: elevation,
    );
  }

  ///Logo view which is app logo displayed on top.
  Widget _logoView() {
    return Center(
      child: SvgPicture.asset(
        AssetPath.workappLogoBlue,
        height: 40,
      ),
    );
  }

  ///when clicking on sign in app button this function is called where validation is managed and api call will be
  ///managed and if any error it will display snack bar for error type and if success it will redirect to home screen.
  Future<void> onSignInPress(LoginLoadedState state) async {
    try {
      if (emailController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyEmailStr, SnackBarType.alert);
      } else if (!emailController.text.trim().isValidEmail()) {
        AppUtils.showSnackBar(AppConstants.emailValidationStr, SnackBarType.alert);
      } else if (passwordController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyPasswordStr, SnackBarType.alert);
      } else {
        await loginCubit.onLoginTap(context,
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            socialMediaType: loginType,
            // 1 is for normal login with email id and password
            rememberMe: state.isChecked,
            socialMediaUserID: socialMediaUserID,
            firstName: firstName,
            lastName: lastName);
      }
    } catch (e) {
      return AppUtils.showSnackBar(AppConstants.retryStr, SnackBarType.alert);
    }
  }

  /// social media row where 3 custom social media buttons which is made below are added for apple, google and linkedIn.
  Widget _socialMediaRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
            visible: Platform.isIOS,
            child: _socialMediaContainer(
                assetPath: AssetPath.appleIcon,
                onTap: () {
                  _appleAuth();
                })),
        Visibility(visible: Platform.isIOS, child: sizedBox29Width()),
        _socialMediaContainer(
            assetPath: AssetPath.google,
            onTap: () {
              _handleGoogleSignIn();
            }),
        sizedBox29Width(),
        _socialMediaContainer(
            assetPath: AssetPath.linkedInIcon,
            onTap: () {
              signInWithLinkedin();
            }),
      ],
    );
  }

  ///this container is made for displaying icons of social media and manage its click event.
  Widget _socialMediaContainer({required String assetPath, required dynamic Function() onTap}) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(assetPath,
                  width: 18.0, height: 20, colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)),
            ),
          ),
        ),
      ],
    );
  }

  /// Don't have account text with sing up option is added where clicking on sign up button will redirect to sign up
  /// screen
  Widget _dontHaveAccount() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppConstants.dontHaveAccountStr,
            style: FontTypography.textFieldHintStyle.copyWith(fontSize: 16.0),
          ),
          sizedBox20Height(),
          _buildSignInBtn(
              function: () {
                if (!isRememberMe) {
                  emailController.clear();
                  passwordController.clear();
                }

                return AppRouter.push(AppRoutes.signUpScreenRoute);
              },
              title: AppConstants.signUpStr,
              bgColor: AppColors.signUpGreenColor,
              elevation: 0),
        ],
      ),
    );
  }

  /// Handle Google Sign In
  Future<void> _handleGoogleSignIn() async {
    try {
      //If current device is Web or Android, do not use any parameters except from scopes.
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

      /// Sign out to force showing the account picker if a user is already signed in.
      await _googleSignIn.signOut();

      /// Attempt to sign in, showing the account picker.
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      /// If no account is selected, account will be null, so we can return early.
      if (account == null) {
        return;
      }

      /// Set the email in the emailController if account is selected.
      emailController.text = account.email;
      String? displayName = account.displayName;
      // Split display name into first and last names
      if (displayName != null) {
        List<String> nameParts = displayName.split(' ');
        firstName = nameParts.isNotEmpty ? nameParts.first : '';
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }

      /// Proceed with the login process using the selected Google account.
      await loginCubit.onLoginTap(
        context,
        socialMediaType: AppConstants.googleLoginType,
        email: emailController.text,
        password: '',
        socialMediaUserID: account.id,
        firstName: firstName,
        lastName: lastName,
      );
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      /// Handle any errors that may occur during Google Sign-in.
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  ///Handle linkedIn Sign In
  Future<void> signInWithLinkedin() async {

    final linkedInConfig = LinkedInConfig(
      clientId: '788tdl7l32wkzz',
      clientSecret: 'WPL_AP1.YnuCXs2HOGgtIp6y.glZgbw==',
      redirectUrl: 'https://www.linkedin.com/uas/oauth2/',
      scope: ['openid', 'profile', 'email'],
    );
    LinkedInUser? linkedInUser;

    SignInWithLinkedIn.signIn(
      context,
      config: linkedInConfig,
      onGetUserProfile: (tokenData, user) {
        log('Auth token data: ${tokenData.toJson()}');
        log('LinkedIn User: ${user.toJson()}');
        linkedInUser = user;
          try {
            // Check if result is of the expected type
            if (linkedInUser!=null) {
              String? email = linkedInUser?.email;
              String? firstName = linkedInUser?.givenName;
              String? lastName = linkedInUser?.familyName;
              String? socialMediaUserId = linkedInUser?.sub;

              // Check that all required fields are not null
              if (socialMediaUserId != null) {
                // Proceed with the login process
                loginCubit.onLoginTap(
                  context,
                  socialMediaType: AppConstants.linkedInLoginType,
                  // Specify the social media type
                  email: email ?? '',
                  password: '',
                  // No password needed for social login
                  socialMediaUserID: socialMediaUserId,
                  firstName: firstName ?? '',
                  lastName: lastName ?? '',
                );

                // Clear input fields if needed
                emailController.clear();
                passwordController.clear();
              } else {}
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
      },
      onSignInError: (error) {
        log('Error on sign in: $error');
      },
    );

  }

  /// Handle apple sign In
  Future<void> _appleAuth() async {
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
        emailController.text = credential.email ?? '';
        await loginCubit.onLoginTap(
          context,
          socialMediaType: AppConstants.appleLoginType,
          email: emailController.text,
          password: '',
          socialMediaUserID: credential.userIdentifier ?? '',
          firstName: firstName,
          lastName: lastName,
        );
        emailController.clear();
        passwordController.clear();
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      AppUtils.showErrorSnackBar(e.message);
      if (kDebugMode) print('_SignInScreenState._appleAuth $e');
    } catch (e) {
      AppUtils.showErrorSnackBar(e.toString());
      if (kDebugMode) print('_SignInScreenState._appleAuth $e');
    }
  }

  ///dispose value after use
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
