import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/otp_verify_screen/bloc/otp_verify_cubit.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/utils/utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 15-01-2025
/// @Message : [OtpVerifyScreen]
///

/// The `EmailVerificationScreen` class is used for adding otp which is send on email id for email verification
/// This view has otp text field where we have to enter 4 digit code send on email
/// Typically it will display email icon with otp text field and send button for otp verification and a resend text
/// with resend button so that we can receive otp mail again on registered email-id.
///
/// Responsibilities:
/// - Display resend text button for email sending if not received or in case on otp expired.
/// - Also has 4 digit text field for entering otp and text which has message of asking to enter otp.
class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String userUUID;
  final bool? isFromSwitchAccount;

  const OtpVerifyScreen({
    super.key,
    required this.email,
    required this.userUUID,
    this.isFromSwitchAccount = false,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> otpController = List.generate(4, (index) => TextEditingController());

  OtpVerifyCubit otpVerifyCubit = OtpVerifyCubit();

  @override
  void initState() {
    otpVerifyCubit.init();
    super.initState();
  }

  ///SingleChildScrollView where it manages keyboard dismiss and layout builder,
  ///which manages constraint with mobile view.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<OtpVerifyCubit, OtpVerifyLoadedState>(
        bloc: otpVerifyCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: MyAppBar(
              title: AppConstants.emailVerificationStr,
              centerTitle: true,
              backBtn: true,
              automaticallyImplyLeading: false,
              shadowColor: AppColors.borderColor,
            ),
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      _mobileView(state),
                      state.isLoading
                          ? LoaderView(
                              height: MediaQuery.sizeOf(context).height / 2,
                              width: MediaQuery.sizeOf(context).width,
                            )
                          : const SizedBox.shrink(),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  ///mobile view where all elements related to displaying on screen are added
  Widget _mobileView(OtpVerifyLoadedState state) {
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
      otpVerifyCubit.verifyOtp(email: widget.email, otp: otp, userUUID: widget.userUUID);
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
              onChanged: (value) {
                if (value.length == 1 && index == otpController.length - 1) {
                  FocusScope.of(context).unfocus();
                } else if (value.length == 1 && index < otpController.length - 1) {
                  FocusScope.of(context).nextFocus();
                } else {
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
  Widget expiringWidget(OtpVerifyLoadedState state) {
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
  Widget _resendText(OtpVerifyLoadedState state) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppConstants.resendOtpTextStr,
            style: FontTypography.textFieldHintStyle,
          ),
          GestureDetector(
            onTap: state.timerDisplay == '00:00' ? () => otpVerifyCubit.resendOtp(context, email: widget.email) : null,
            child: Text(
              AppConstants.resendStr,
              style: state.timerDisplay == '00:00'
                  ? FontTypography.signUpRouteStyle.copyWith(fontSize: 14.0)
                  : FontTypography.textFieldHintStyle.copyWith(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}
