import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/sign_up/bloc/sign_up_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04-09-2024
/// @Message : [SignUpView]

class SignUpView extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String socialMediaUserId;
  final bool isFromSocialAuth;

  const SignUpView({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.socialMediaUserId,
    required this.isFromSocialAuth,
  });

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // first name, last name, email, password, confirm password, mobile number text edit controller.
  final firstNameTxtController = TextEditingController();
  final lastNameTxtController = TextEditingController();
  final emailTxtController = TextEditingController();
  final confirmEmailTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();
  final confirmPasswordTxtController = TextEditingController();
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();
  String phoneDialCode = '+91';
  String phoneCountryCode = 'IN';
  String socialMediaUserId = '';
  int loginType = AppConstants.normalLoginType;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _confirmEmailFocusNode = FocusNode();
  final FocusNode _mobileNoFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  ///SignUpCubit initializing to call in bloc builder and calling cubit methods where need to manage state
  SignUpCubit signUpCubit = SignUpCubit();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  final List<TextInputFormatter> _nameInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
  ];

  ///init state to call all initial methods which needs to call when loading ui and data displaying using cubit and
  ///initializing cubit init method for adding Loaded state.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      signUpCubit.init();
      firstNameTxtController.text = widget.firstName;
      lastNameTxtController.text = widget.lastName;
      emailTxtController.text = widget.email;
      confirmEmailTxtController.text = widget.email;
      socialMediaUserId = widget.socialMediaUserId;

      await AppUtils.showAlertDialog(
        context,
        title: AppConstants.thanksTitleStr,
        description: AppConstants.infoSubTextStr,
        confirmationText: AppConstants.okStr,
        onOkPressed: () {
          navigatorKey.currentState?.pop();
        },
      );
    });
    super.initState();
  }

  /// Single child scroll view where added layout builder for mobile view and managing keyboard dismiss on scroll.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<SignUpCubit, SignUpState>(
        bloc: signUpCubit,
        builder: (context, state) {
          if (state is SignUpLoadedState) {
            return Stack(
              children: [
                SafeArea(
                  bottom: false,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _mobileView(state);
                        },
                      ),
                    ),
                  ),
                ),
                state.loading ? const LoaderView() : const SizedBox.shrink(),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  ///mobile view which has logo, sub title, first and last name text-field row, email txt-field, mobile txt field,
  ///password and confirm password txt field, account type and register personal account type drop down, submit
  ///button to register account, divider and or divider for diving social media login option and lastly to go back to
  /// on sign up screen we have text button.
  Widget _mobileView(SignUpLoadedState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sizedBox10Height(),
        _logoView(),
        sizedBox30Height(),
        _signSubTitleView(),
        sizedBox20Height(),
        _accountType(state),
        sizedBox20Height(),
        _firstLastNameRow(),
        sizedBox20Height(),
        _emailTxtField(),
        sizedBox20Height(),
        _confirmEmailTxtField(),
        sizedBox20Height(),
        AppMobileTextField(
          focusNode: _mobileNoFocusNode,
          onSubmitted: () {
            _emailFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          mobileTextEditController: mobileTxtController,
          phoneCodeController: phoneCodeController,
          countryCodeController: countryCodeController,
        ),
        sizedBox10Height(),
        Visibility(
          visible: !(state.isFromGoogleAuth || widget.isFromSocialAuth),
          child: _passwordTxtField(
              obscureText: !state.showPassword,
              controller: passwordTxtController,
              onTap: () => signUpCubit.onShowPassword(),
              hintText: AppConstants.passwordRequiredStr,
              suffixChildIcon: (state.showPassword)
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
              textInputAction: TextInputAction.next,
              focusNode: _passwordFocusNode,
              onSubmitted: () {
                _mobileNoFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
              }),
        ),
        Visibility(visible: !(state.isFromGoogleAuth || widget.isFromSocialAuth), child: sizedBox20Height()),
        Visibility(
          visible: !state.isFromGoogleAuth,
          child: _passwordTxtField(
              obscureText: !state.showConfirmPassword,
              controller: confirmPasswordTxtController,
              onTap: () => signUpCubit.onShowConfirmPassword(),
              hintText: AppConstants.confPassRequiredStr,
              suffixChildIcon: (state.showConfirmPassword)
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
              textInputAction: TextInputAction.done,
              focusNode: _confirmPasswordFocusNode,
              onSubmitted: () {
                _passwordFocusNode.unfocus();
                _confirmPasswordFocusNode.unfocus();
              }),
        ),
        Visibility(visible: !state.isFromGoogleAuth, child: sizedBox20Height()),
        sizedBox20Height(),
        _termsCondition(state),
        sizedBox20Height(),
        _buildSignInBtn(state),
        sizedBox20Height(),
        _orDivider(),
        sizedBox20Height(),
        _socialMediaRow(),
        sizedBox14Height(),
        _alreadyHaveAccount()
      ],
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

  ///This widget used for signIn sub title view which indicated the screen name and small welcome note.
  Widget _signSubTitleView() {
    return Center(
      child: Column(
        children: [
          Text(
            AppConstants.signUpStr,
            style: FontTypography.signInBoldStyle,
          ),
          sizedBox10Height(),
          Text(
            AppConstants.signUpSubStr,
            style: FontTypography.subTextStyle,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  ///First Name and Last Name text-field in single row for new registration
  Widget _firstLastNameRow() {
    return Row(
      children: [_nameTextField(controller: firstNameTxtController, hintText: '${AppConstants.firstNameStr}*'), sizedBox20Width(), _nameTextField(controller: lastNameTxtController, hintText: '${AppConstants.lastNameStr}*')],
    );
  }

  ///custom common text field for common view for both first n last name with different text edit controller where we
  ///need to define when calling it and it is mandatory.
  Widget _nameTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Flexible(
      child: AppTextField(
        hintTxt: hintText,
        keyboardType: TextInputType.text,
        inputFormatters: _nameInputFormatter,
        controller: controller,
        maxLines: 1,
        maxLength: 50,
        textInputAction: TextInputAction.next,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset(
            AssetPath.personIcon,
            fit: BoxFit.contain,
            height: 10.0,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  /// Email text-field where user has to enter it's registered email address for sign-up
  /// where value is passed in text edit controller (i.e. controller).
  /// it uses AppTextField which is custom designed text-field for the app and it is not mandatory.
  Widget _emailTxtField() {
    return AppTextField(
      controller: emailTxtController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      hintTxt: AppConstants.enterEmailHintRequiredStr,
      focusNode: _emailFocusNode,
      textCapitalization: TextCapitalization.none,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          AssetPath.emailIcon,
          fit: BoxFit.contain,
          height: 9.0,
          width: 9.0,
        ),
      ),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_confirmEmailFocusNode);
      },
    );
  }

  Widget _confirmEmailTxtField() {
    return AppTextField(
      controller: confirmEmailTxtController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      hintTxt: AppConstants.enterConfirmEmailHintRequiredStr,
      focusNode: _confirmEmailFocusNode,
      textCapitalization: TextCapitalization.none,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          AssetPath.emailIcon,
          fit: BoxFit.contain,
          height: 9.0,
          width: 9.0,
        ),
      ),
      onEditingComplete: () {
        _emailFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_mobileNoFocusNode);
      },
    );
  }

  ///Password Text Field is used for both password and confirm password with all the required details mentioned while
  /// calling the text field and it is not mandatory.
  Widget _passwordTxtField({
    required String hintText,
    required bool obscureText,
    required TextEditingController controller,
    required void Function() onTap,
    required Widget suffixChildIcon,
    required TextInputAction textInputAction,
    FocusNode? focusNode,
    void Function()? onSubmitted,
  }) {
    return AppTextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: 1,
      hintTxt: hintText,
      textInputAction: textInputAction,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          AssetPath.passwordLockIcon,
          fit: BoxFit.contain,
          height: 10.0,
          width: 10.0,
        ),
      ),
      suffixIcon: InkWell(onTap: onTap, child: suffixChildIcon),
      focusNode: focusNode,
      onEditingComplete: onSubmitted,
    );
  }

  ///Register personal account type drop down in case of adding any personal account in app not mandatory.
  Widget _accountType(SignUpLoadedState state) {
    // Mapping of profile visibility options
    final accountTypeOptions = {
      EnumType.businessAccountType: AppConstants.businessStr,
      EnumType.personalAccountType: AppConstants.personalStr,
    };

    return DropdownButtonHideUnderline(
      child: DropdownButton2<int>(
        isExpanded: true,
        hint: Text(AppConstants.accountType, style: FontTypography.textFieldHintStyle),
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
                  // Display the corresponding string for the selected int value
                  accountTypeOptions[state.accountType] ?? AppConstants.accountType,
                  style: FontTypography.textFieldHintStyle,
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
        items: accountTypeOptions.entries.map(
          (entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Row(
                children: [
                  // Add icon based on the entry key
                  SvgPicture.asset(
                    entry.key == 1 ? AssetPath.businessAccountTypeIcon : AssetPath.personalAccountTypeIcon,
                    width: 12, // Adjust icon size as needed
                    height: 12,
                  ),
                  const SizedBox(width: 10), // Space between icon and text
                  Text(
                    entry.value, // Display the corresponding string
                    style: FontTypography.textFieldBlackStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ).toList(),
        value: state.accountType,
        onChanged: (int? value) {
          signUpCubit.accountTypeChange(value ?? 0);
        },
      ),
    );
  }

  ///Terms and condition check box which indicates that we accept the app terms and condition before registering.
  Widget _termsCondition(SignUpLoadedState state) {
    return Row(
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
            value: state.isTNCChecked,
            onChanged: (value) => signUpCubit.onIsTermCondCheck(),
          ),
        ),
        sizedBox10Width(),
        Expanded(
          child: RichText(
            maxLines: 2,
            softWrap: true,
            text: TextSpan(
              text: AppConstants.registeringTextStr,
              style: FontTypography.subTextStyle,
              children: <TextSpan>[
                TextSpan(text: '${AppConstants.registeringTCStr} ', style: FontTypography.subTextStyle.copyWith(color: AppColors.primaryColor), recognizer: TapGestureRecognizer()..onTap = () => AppRouter.push(AppRoutes.termsConditionScreen, args: {ModelKeys.cmsTypeIdStr: ApiConstant.termConditionsInt})),
                TextSpan(text: AppConstants.registeringAndStr, style: FontTypography.subTextStyle),
                TextSpan(text: AppConstants.registeringPrivacyStr, style: FontTypography.subTextStyle.copyWith(color: AppColors.primaryColor), recognizer: TapGestureRecognizer()..onTap = () => AppRouter.push(AppRoutes.termsConditionScreen, args: {ModelKeys.cmsTypeIdStr: ApiConstant.privacyPolicyInt}))
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// AppButton used for sign in option and sign in as guest button where function is managed when in used and title
  /// managed as per need and bgColor to change button color if needed as we can see 2 buttons on screen with
  /// different colors and functions.
  Widget _buildSignInBtn(SignUpLoadedState state) {
    return AppButton(function: () => onSignUpPress(state), title: AppConstants.signUpStr);
  }

  ///Or Divider Widget for social media sign in option and form
  Widget _orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SvgPicture.asset(AssetPath.orDivider),
    );
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
                _signUpWithApple();
              }),
        ),
        Visibility(visible: Platform.isIOS, child: sizedBox29Width()),
        _socialMediaContainer(
            assetPath: AssetPath.google,
            onTap: () {
              _handleGoogleSignUp();
            }),
        sizedBox29Width(),
        _socialMediaContainer(
            assetPath: AssetPath.linkedInIcon,
            onTap: () {
              signUpWithLinkedin();
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
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(color: AppColors.dropShadowColor.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(1, 2)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(assetPath, width: 18.0, height: 20, colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)),
            ),
          ),
        ),
      ],
    );
  }

  /// Already have account text with sign in option is added where clicking on sign in button will redirect to sign in
  /// screen
  Widget _alreadyHaveAccount() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppConstants.alreadyHaveAccountStr, style: FontTypography.alreadyHaveAccountStyle),
          GestureDetector(
            onTap: () => AppRouter.pop(),
            child: Text(
              AppConstants.signInStr,
              style: FontTypography.subTitleStyle.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  ///when clicking on sign in app button this function is called where validation is managed and api call will be
  ///managed and if any error it will display snack bar for error type and if success it will redirect to home screen.
  Future<void> onSignUpPress(SignUpLoadedState state) async {
    try {
      // Validate First Name
      if (state.accountType == 0 || state.accountType == null) {
        AppUtils.showSnackBar(AppConstants.accountTypeStr, SnackBarType.alert);
        return;
      }
      // Validate First Name
      if (firstNameTxtController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyFirstNameStr, SnackBarType.alert);
        return;
      }

      // Validate Last Name
      if (lastNameTxtController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyLastNameStr, SnackBarType.alert);
        return;
      }

      // Validate Email
      if (emailTxtController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyEmailStr, SnackBarType.alert);
        return;
      } else if (!emailTxtController.text.trim().isValidEmail()) {
        AppUtils.showSnackBar(AppConstants.emailValidationStr, SnackBarType.alert);
        return;
      }

      // Validate Confirm Email
      if (emailTxtController.text.trim().isNotEmpty && confirmEmailTxtController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyConfirmEmailStr, SnackBarType.alert);
        return;
      } else if (confirmEmailTxtController.text.trim() != emailTxtController.text.trim()) {
        AppUtils.showSnackBar(AppConstants.confirmEmailValidationStr, SnackBarType.alert);
        return;
      }

      // Validate Mobile
      // Define the mobile number pattern (example for 10-digit numbers)
      if (mobileTxtController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyMobileStr, SnackBarType.alert);
        return;
      } else if (!checkPhoneNo(countryCodeController.text)) {
        AppUtils.showSnackBar(AppConstants.validMobileStr, SnackBarType.alert);
        return;
      }

      // Additional validations if the sign-up is not from Google Auth
      if (!state.isFromGoogleAuth) {
        // Validate Password
        if (passwordTxtController.text.trim().isEmpty) {
          AppUtils.showSnackBar(AppConstants.pleaseEnterPasswordStr, SnackBarType.alert);
          return;
        } else if (passwordTxtController.text.trim().length < 8) {
          AppUtils.showSnackBar(AppConstants.password8Char, SnackBarType.alert);
          return;
        } else if (!passwordTxtController.text.trim().isValidPassword()) {
          AppUtils.showSnackBar(AppConstants.passwordSpecialChar, SnackBarType.alert);
          return;
        }

        // Validate Confirm Password
        if (passwordTxtController.text.trim().isNotEmpty && confirmPasswordTxtController.text.trim().isEmpty) {
          AppUtils.showSnackBar(AppConstants.plsEnterConfNewPassStr, SnackBarType.alert);
          return;
        } else if (passwordTxtController.text.trim() != confirmPasswordTxtController.text.trim()) {
          AppUtils.showSnackBar(AppConstants.matchPasswordStr, SnackBarType.alert);
          return;
        }
      }

      // Validate Terms and Conditions
      if (state.isTNCChecked != true) {
        AppUtils.showSnackBar(AppConstants.acceptTnCPrivacyPolicy, SnackBarType.alert);
        return;
      }
      var trimmed = mobileTxtController.text.trim();
      final withoutLeadingZero = trimmed.startsWith('0') ? trimmed.substring(1) : trimmed;
      // Sign Up user if all fields are filled and verified
      await signUpCubit.onSignUpTap(
        context,
        currencyUUID: '',
        countryUUID: '',
        firstName: firstNameTxtController.text.trim(),
        lastName: lastNameTxtController.text.trim(),
        email: emailTxtController.text.trim(),
        biography: '',
        gender: '',
        address: '',
        city: '',
        profilePic: '',
        countryCode: state.countryPhoneCode ?? '',
        phoneNumber: withoutLeadingZero,
        phoneCountryCode: phoneCountryCode,
        phoneDialCode: phoneDialCode,
        accountType: state.accountType ?? 0,
        password: passwordTxtController.text.trim(),
        socialMediaType: loginType,
        socialMediaUserID: socialMediaUserId,
      );
    } catch (e) {
      if (kDebugMode) {
        print('----$this---${e.toString()}');
      }
      AppUtils.showSnackBar(AppConstants.retryStr, SnackBarType.alert);
    }
  }

  /// handle google signup
  Future<void> _handleGoogleSignUp() async {
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
      emailTxtController.text = account.email;
      confirmEmailTxtController.text = account.email;
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
      firstNameTxtController.text = firstName;
      lastNameTxtController.text = lastName;
      passwordTxtController.clear(); // clear password
      confirmPasswordTxtController.clear();
      signUpCubit.setGoogleSignUp(true);
      await signUpCubit.handleExistingUserLogin(
        context,
        firstName: firstName,
        lastName: lastName,
        email: emailTxtController.text.trim(),
        password: passwordTxtController.text.trim(),
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

  ///Handle linkedIn Sign In
  Future<void> signUpWithLinkedin() async {

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

            String? socialMediaUserId = linkedInUser?.sub;

            loginType = AppConstants.linkedInLoginType;
            firstNameTxtController.text = linkedInUser?.givenName ?? '';
            lastNameTxtController.text = linkedInUser?.familyName ?? '';
            emailTxtController.text = linkedInUser?.email ?? '';
            String profilePic = linkedInUser?.picture ?? '';

            if (socialMediaUserId != null) {
              // Proceed with the login process
              signUpCubit.handleExistingUserLogin(
                context,
                firstName: firstNameTxtController.text.trim(),
                lastName: lastNameTxtController.text.trim(),
                email: emailTxtController.text.trim(),
                password: passwordTxtController.text.trim(),
                socialMediaType: loginType,
                socialMediaUserID: socialMediaUserId,
                profilePic: profilePic,
              );

              // Clear input fields if needed
              emailTxtController.clear();
              passwordTxtController.clear();
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
      },
      onSignInError: (error) {
        log('Error on sign in: $error');
      },
    );

  }

  Future<void> _signUpWithApple() async {
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
        emailTxtController.text = credential.email ?? '';
        firstNameTxtController.text = firstName;
        lastNameTxtController.text = lastName;
        if (credential.identityToken != null) {
          // Proceed with the login process
          signUpCubit.handleExistingUserLogin(
            navigatorKey.currentContext ?? context,
            firstName: firstNameTxtController.text.trim(),
            lastName: lastNameTxtController.text.trim(),
            email: emailTxtController.text.trim(),
            password: '',
            socialMediaType: AppConstants.appleLoginType,
            socialMediaUserID: credential.userIdentifier ?? '',
            profilePic: '',
          );
          // Clear input fields if needed
          emailTxtController.clear();
          passwordTxtController.clear();
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

  bool checkPhoneNo(String countryCode) {
    var country = countries.where((element) {
      return element.code == countryCode;
    }).toList();
    var minLength = country.first.minLength;
    var maxLength = country.first.maxLength;
    phoneCountryCode = country.first.code;
    phoneDialCode = '+${country.first.dialCode}';

    final text = mobileTxtController.text.trim();
    final effectiveLength = text.startsWith('0') ? text.length - 1 : text.length;

    final RegExp mobilePattern = RegExp(r'^\d+$'); // Only digits
    if (!mobilePattern.hasMatch(mobileTxtController.text.trim())) {
      return false;
    } else if (effectiveLength < minLength || effectiveLength > maxLength) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    emailTxtController.clear();
    firstNameTxtController.clear();
    lastNameTxtController.clear();
    passwordTxtController.clear();
    confirmPasswordTxtController.clear();
    super.dispose();
  }
}
