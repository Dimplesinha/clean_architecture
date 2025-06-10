import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/app_bar.dart';
import 'package:workapp/src/presentation/common_widgets/app_btn.dart';
import 'package:workapp/src/presentation/common_widgets/loader_view.dart';
import 'package:workapp/src/presentation/modules/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04-09-2024
/// @Message : [ForgotPassword]

/// The `ForgetPassword` class is used for sending registered email id for getting new password or change new password
/// if user has forgotten its sign in password.
/// This view can be seen from sign in screen when clicked on forgot password text.
/// Typically, it shows the email text field for adding registered email and click on send button to get email.
///
/// Responsibility:
/// - Displays one text field for email and one button to send link which contains api call on click.

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ForgotPasswordCubit forgotPasswordCubit = ForgotPasswordCubit();

  /// Email Text Editing controller used for app text-field for data storing
  final emailTxtController = TextEditingController();

  @override
  void initState() {
    forgotPasswordCubit.init();
    super.initState();
  }

  ///SingleChildScroll view to control scroll which also allows to dismiss keyboard on drag
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
        bloc: forgotPasswordCubit,
        builder: (context, state) {
          if (state is ForgotPasswordLoadedState) {
            return SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Scaffold(
                    appBar: MyAppBar(
                      title: AppConstants.forgotPasswordTitleStr,
                      centerTitle: true,
                      backBtn: true,
                      automaticallyImplyLeading: false,
                      shadowColor: AppColors.borderColor,
                    ),
                    body: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return _mobileView();
                        },
                      ),
                    ),
                  ),
                  state.isLoading ? const LoaderView() : const SizedBox.shrink()
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  ///Mobile view which has circle avatar for design and email text field and submit button in column view
  Widget _mobileView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          sizedBox50Height(),
          _circleLockIcon(),
          sizedBox40Height(),
          _subTitleText(),
          sizedBox40Height(),
          _emailTxtField(),
          sizedBox20Height(),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _circleLockIcon() {
    return CircleAvatar(
      radius: 80.0,
      backgroundColor: AppColors.circleColor,
      child: SvgPicture.asset(AssetPath.forgotPasswordLock),
    );
  }

  Widget _subTitleText() {
    return Center(
      child: Text(
        AppConstants.forgetPasswordSubStr,
        style: FontTypography.subString,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Email text-field where user has to enter it's registered email address for login which will be used for sending
  /// email of forgotten password.
  /// where value is passed in texteditcontroller (i.e. controller).
  /// it uses AppTextField which is custom designed text-field for the app.
  Widget _emailTxtField() {
    return AppTextField(
      controller: emailTxtController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      hintTxt: AppConstants.enterEmailHintStr,
      textCapitalization: TextCapitalization.none,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset(
            AssetPath.emailIcon,
            fit: BoxFit.contain,
            height: 9.0,
            width: 9.0,
          ),
        )
    );
  }

  /// Submit button when clicking on send it will send email and will check if email is empty or not and valid or not
  Widget _submitButton() {
    return AppButton(
      function: () => onSendClick(),
      title: AppConstants.sendStr,
    );
  }

  ///OnSendClick this is called when clicked on send button with email empty check and email validation check
  void onSendClick() {
    if (emailTxtController.text.trim().isEmpty) {
      AppUtils.showSnackBar(AppConstants.emptyEmailStr, SnackBarType.alert);
    } else if (!emailTxtController.text.trim().isValidEmail()) {
      AppUtils.showSnackBar(AppConstants.emailValidationStr, SnackBarType.alert);
    } else {
      ///called from cubit for api call
      forgotPasswordCubit.onSendClick(context, email: emailTxtController.text.trim(),isFromResend: false, otpType: EnumType.forgotPassword,);
    }
  }
}
