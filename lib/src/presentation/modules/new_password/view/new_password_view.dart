import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/new_password/bloc/new_password_cubit.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 05-09-2024
/// @Message : [NewPasswordScreen]

///The `NewPasswordScreen` class is added for adding new password in case of any password not added or forgotten the
///previous password.
///This view contains 2 password fields and one submit button.
///Typically, it will show icon and after that 2 text field for password and confirm password and than one submit
///button.
///
/// Responsibilities:
/// - Display password text-fields.
/// - Submit button for adding password and api call for same.

class NewPasswordScreen extends StatefulWidget {
  final String token;
  final bool isForSetPassword;

  const NewPasswordScreen({super.key, required this.token, required this.isForSetPassword});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  ///NewPasswordCubit for managing state
  NewPasswordCubit newPasswordCubit = NewPasswordCubit();

  /// Password and confirm password text edit controller used for app text-field for data storing.
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  ///Init state for calling all init state method on UI loading and adding cubit to initialize
  @override
  void initState() {
    newPasswordCubit.init();
    super.initState();
  }

  ///SingleChildScroll view to control scroll which also allows to dismiss keyboard on drag and layout builder for
  ///managing view, and bloc builder adding use state and call methods from cubit.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<NewPasswordCubit, NewPasswordState>(
        bloc: newPasswordCubit,
        builder: (context, state) {
          if (state is NewPasswordLoadedState) {
            return Stack(
              children: [
                SafeArea(
                  bottom: false,
                  child: Scaffold(
                    appBar: MyAppBar(
                      title: AppConstants.newPasswordStr,
                      backBtn: true,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      shadowColor: AppColors.borderColor,
                    ),
                    body: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return _mobileView(state);
                      }),
                    ),
                  ),
                ),
                state.loading ? const LoaderView() : const SizedBox.shrink()
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  ///mobile view with 2 password field for comparison and icon view and submit button
  Widget _mobileView(NewPasswordLoadedState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizedBox50Height(),
          _circleLockIcon(),
          sizedBox40Height(),
          _subTitleText(),
          sizedBox40Height(),
          _passwordTxtField(
            textInputAction: TextInputAction.next,
            obscureText: !state.showPassword,
            controller: passwordController,
            onTap: () => newPasswordCubit.onShowPassword(),
            hintText: AppConstants.passwordStr,
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
          ),
          sizedBox20Height(),
          _passwordTxtField(
            textInputAction: TextInputAction.done,
            obscureText: !state.showConfirmPassword,
            controller: confirmPasswordController,
            onTap: () => newPasswordCubit.onShowConfirmPassword(),
            hintText: AppConstants.enterNewConfPassStr,
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
          ),
          sizedBox20Height(),
          _submitButton()
        ],
      ),
    );
  }

  ///Circle with lock icon used for logo
  Widget _circleLockIcon() {
    return CircleAvatar(
      radius: 80.0,
      backgroundColor: AppColors.circleColor,
      child: SvgPicture.asset(AssetPath.newPasswordLock),
    );
  }

  ///Sub title is for information that how password should be.
  Widget _subTitleText() {
    return Center(
        child: Text(
      AppConstants.newPasswordSubStr,
      style: FontTypography.subString,
      textAlign: TextAlign.center,
    ));
  }

  ///Password Text Field is used for both password and confirm password with all the required details mentioned while
  /// calling the text field
  Widget _passwordTxtField(
      {required String hintText,
      required bool obscureText,
      required TextEditingController controller,
      required void Function() onTap,
      required TextInputAction textInputAction,
      required Widget suffixChildIcon}) {
    return AppTextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: 1,
      hintTxt: hintText,
      textInputAction: textInputAction,
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
    );
  }

  /// Submit button for submit tap call
  Widget _submitButton() {
    return AppButton(
      function: () => onSubmitClick(),
      title: AppConstants.submitStr,
    );
  }

  /// on submit click is for checking if password and confirm password is empty or not and both the password matchs
  /// or not if yes then it will redirect to next route screen
  void onSubmitClick() {
    if (passwordController.text.trim().isEmpty) {
      AppUtils.showSnackBar(AppConstants.emptyPasswordStr, SnackBarType.alert);
    } else if (passwordController.text.trim().length < 8) {
      AppUtils.showSnackBar(AppConstants.newPass8CharStr, SnackBarType.alert);
    } else if (!passwordController.text.trim().isValidPassword()){
      AppUtils.showSnackBar(AppConstants.passwordSpecialChar, SnackBarType.alert);
    } else if (passwordController.text.trim().isNotEmpty && passwordController.text.trim().isEmpty) {
      AppUtils.showSnackBar(AppConstants.plsEnterConfNewPassStr, SnackBarType.alert);
    }  else if (!passwordController.text.trim().isValidPassword()) {
      AppUtils.showSnackBar(AppConstants.passwordValidStr, SnackBarType.alert);
    }  else if (confirmPasswordController.text.trim().isEmpty) {
      AppUtils.showSnackBar(AppConstants.plsEnterConfNewPassStr, SnackBarType.alert);
    } else if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      AppUtils.showSnackBar(AppConstants.confirmPassNotMatch, SnackBarType.alert);
    } else {
      ///Add the route and api call for new password
      if(!widget.isForSetPassword) {
        newPasswordCubit.onSendClick(
        context,
        newPassword: passwordController.text.trim(),
        confirmNewPassword: confirmPasswordController.text.trim(),
        token: widget.token,
      );
      }
      else{
        newPasswordCubit.onSetPassword(
          context,
          newPassword: passwordController.text.trim(),
          confirmNewPassword: confirmPasswordController.text.trim(),
        );
      }
    }
  }
}
