import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/utils/utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04-09-2024
/// @Message : [EmailVerificationScreen]
///

/// The `EmailVerificationScreen` class is used for adding otp which is send on email id for email verification
/// This view has otp text field where we have to enter 4 digit code send on email
/// Typically it will display email icon with otp text field and send button for otp verification and a resend text
/// with resend button so that we can receive otp mail again on registered email-id.
///
/// Responsibilities:
/// - Display resend text button for email sending if not received or in case on otp expired.
/// - Also has 4 digit text field for entering otp and text which has message of asking to enter otp.
class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String newEmail;
  final int otpType;
  final bool isFromSignUp;
  final bool isFromChangeEmail;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.otpType,
    required this.isFromSignUp,
    required this.isFromChangeEmail,
    required this.newEmail,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> otpController = List.generate(4, (index) => TextEditingController());

  ForgotPasswordCubit forgotPasswordCubit = ForgotPasswordCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isFromSignUp) {
        await AppUtils.showAlertDialog(
          context,
          title: AppConstants.welcomeToWorkappStr,
          description: AppConstants.emailVerificationSubTitleStr,
          confirmationText: AppConstants.okStr,
          onOkPressed: () {
            navigatorKey.currentState?.pop();
          },
        );
      }
      forgotPasswordCubit.init();
    });

    for (int i = 0; i < otpController.length; i++) {
      otpController[i].addListener(() => _handlePaste(i));
    }
    super.initState();
  }

  void _handlePaste(int index) {
    final text = otpController[index].text;
    if (text.length > 1) {
      // User pasted value like "1234"
      for (int i = 0; i < otpController.length; i++) {
        otpController[i].text = i < text.length ? text[i] : '';
      }
      FocusScope.of(context).unfocus(); // optionally dismiss keyboard
    }
  }


  ///SingleChildScrollView where it manages keyboard dismiss and layout builder,
  ///which manages constraint with mobile view.
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
                      title: AppConstants.emailVerificationStr,
                      centerTitle: true,
                      backBtn: true,
                      automaticallyImplyLeading: false,
                      shadowColor: AppColors.borderColor,
                    ),
                    body: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: LayoutBuilder(builder: (context, constraint) {
                        return _mobileView(state);
                      }),
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

  ///mobile view where all elements related to displaying on screen are added
  Widget _mobileView(ForgotPasswordLoadedState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizedBox50Height(),
          _circleEmailVerificationIcon(),
          sizedBox40Height(),
          _subTitleText(),
          sizedBox40Height(),
          _verificationTextField(),
          sizedBox20Height(),
          _submitButton(),
          sizedBox30Height(),
          expiringWidget(state),
          sizedBox10Height(),
          _resendText(state),
        ],
      ),
    );
  }

  /// Email verification icon with circle avatar background to display on top.
  Widget _circleEmailVerificationIcon() {
    return CircleAvatar(
      radius: 80.0,
      backgroundColor: AppColors.circleColor,
      child: SvgPicture.asset(AssetPath.emailVerificationIcon),
    );
  }

  ///Email verification text which is added for displaying message.
  Widget _subTitleText() {
    return Center(
        child: Text(
      AppConstants.emailVerificationSubStr,
      style: FontTypography.subString,
      textAlign: TextAlign.center,
    ));
  }

  /// Send button when clicking on send it will send email and will check if otp is empty or not.
  Widget _submitButton() {
    return AppButton(
      function: () => onSendClick(),
      title: AppConstants.sendStr,
    );
  }

  ///onSendClick which checks otp text edit controller and joins the code together and checks length of code if not
  ///it will display snackBar.
  void onSendClick() {
    String otp = otpController.map((controller) => controller.text).join();
    if (otp.length < 4) {
      AppUtils.showSnackBar(AppConstants.otpValidation, SnackBarType.alert);
    } else {
      if (widget.newEmail.isNotEmpty) {
        forgotPasswordCubit.onEmailVerifySendClick(context,
            email: widget.email,
            otpCode: otp,
            otpType: widget.otpType,
            isFromSignUp: widget.isFromSignUp,
            newEmail: widget.newEmail);
      } else {
        ///for calling otp verify api call from cubit
        forgotPasswordCubit.onVerifySendClick(context,
            isFromChangeEmail: widget.isFromChangeEmail,
            email: widget.email,
            otpCode: otp,
            otpType: widget.otpType,
            isFromSignUp: widget.isFromSignUp);
      }
      _clearOtpFields();
    }
  }

  /// used for clearing entered otp or rewrite otp if added incorrect.
  void _clearOtpFields() {
    for (var controller in otpController) {
      controller.clear();
    }
  }

  /// verification list text field used for entering 4 digit otp and increase cursor when 1 text field has value.
  Widget _verificationTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        otpController.length,
        (index) => SizedBox(
          width: 40,
          height: 40,
          child: Material(
            elevation: 3.0,
            shadowColor: AppColors.borderColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(constBorderRadius),
            child: TextField(
              cursorColor: AppColors.primaryColor,
              controller: otpController[index],
              keyboardType: TextInputType.number,
              maxLength: 1,
              textAlign: TextAlign.center,
              inputFormatters: [
                OtpInputFormatter(
                  context: context,
                  controllers: otpController,
                  currentIndex: index,
                ),
              ],
              onChanged: (value) {
                if (value.isNotEmpty && index < otpController.length - 1) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }
              },
              decoration: const InputDecoration().decoration.copyWith(
                    counterText: '',
                    contentPadding: const EdgeInsets.only(left: 0, right: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(constBorderRadius),
                      borderSide: BorderSide(color: AppColors.borderColor),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  ///Expiring timer widget to display timer on screen for the received otp
  Widget expiringWidget(ForgotPasswordLoadedState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: !(state.timerDisplay == '00:00'),
          child: Text(
            AppConstants.expectOTPStr,
            style: FontTypography.textFieldHintStyle,
          ),
        ),
        Visibility(
          visible: !(state.timerDisplay == '00:00'),
          child: Text(
            state.timerDisplay,
            style:
                FontTypography.textFieldHintStyle.copyWith(fontWeight: FontWeight.w600, color: AppColors.jetBlackColor),
          ),
        ),
      ],
    );
  }

  ///Resend text button from where we can add api call of getting otp again.
  Widget _resendText(ForgotPasswordLoadedState state) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppConstants.resendOtpTextStr,
            style: FontTypography.textFieldHintStyle,
          ),
          GestureDetector(
            onTap: state.timerDisplay == '00:00'
                ? () {
                    if (widget.isFromSignUp) {
                      forgotPasswordCubit.resendEmailVerificationOtp(context, email: widget.email);
                    } else if (widget.isFromChangeEmail) {
                      forgotPasswordCubit.resendChangeEmailVerificationOtp(context,
                          oldEmail: widget.email, newEmail: widget.newEmail, otpType: 5);
                    } else {
                      forgotPasswordCubit.onSendClick(context,
                          email: widget.email, isFromResend: true, otpType: EnumType.forgotPassword);
                    }
                  }
                : null,
            child: Text(
              AppConstants.resendStr,
              style: state.timerDisplay == '00:00'
                  ? FontTypography.signUpRouteStyle.copyWith(
                      fontSize: 14.0,
                    )
                  : FontTypography.textFieldHintStyle.copyWith(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}

class OtpInputFormatter extends TextInputFormatter {
  final List<TextEditingController> controllers;
  final int currentIndex;
  final BuildContext context;

  OtpInputFormatter({
    required this.controllers,
    required this.currentIndex,
    required this.context,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 1) {
      final pastedText = newValue.text;
      final length = controllers.length;

      for (int i = 0; i < length; i++) {
        controllers[i].text = i < pastedText.length ? pastedText[i] : '';
      }

      // Move focus to last filled field
      final lastIndex = pastedText.length.clamp(0, length);
      FocusScope.of(context).requestFocus(FocusNode()); // Remove focus briefly
      Future.delayed(const Duration(milliseconds: 10), () {
        FocusScope.of(context).requestFocus(
          FocusScope.of(context).children.elementAt(lastIndex),
        );
      });

      return TextEditingValue(
        text: pastedText[0], // Only the first char for this field
        selection: TextSelection.collapsed(offset: 1),
      );
    }
    return newValue;
  }
}
