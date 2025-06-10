import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/presentation/common_widgets/app_btn.dart';
import 'package:workapp/src/presentation/common_widgets/loader_view.dart';
import 'package:workapp/src/presentation/modules/change_password/cubit/change_password_cubit.dart';
import 'package:workapp/src/presentation/modules/change_password/repo/change_password_repo.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03/09/24
/// @Message : [ChangePasswordScreen]
///
/// The `ChangePasswordView` class provides a user interface for changing the app password.
///
/// Responsibilities:
/// - Display input fields for the current password, new password, and
///   confirm password.
/// - Include password visibility toggles.
/// - Validate that the current password is correct and the new passwords match.
/// - Submit the form to change the password, handling errors or success messages.
///
/// Flow:
/// 1. User enters current and new passwords.
/// 2. System validates the input.
/// 3. On success, the password is updated, and the user is notified.

class ChangePasswordScreen extends StatefulWidget {

  const ChangePasswordScreen({super.key,});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPassTxtController = TextEditingController();
  final newPassTxtController = TextEditingController();
  final confirmPassTxtController = TextEditingController();

  final ChangePasswordCubit changePasswordCubit = ChangePasswordCubit(changePasswordRepo: ChangePasswordRepo.instance);

  bool isCurrentPassVisible = false;
  bool isNewPassVisible = false;
  bool isConfirmPassVisible = false;
  final FocusNode _currentPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    changePasswordCubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          bloc: changePasswordCubit,
          builder: (context, state) {
            if (state is ChangePasswordLoadedState) {
              return Scaffold(
                appBar: MyAppBar(
                  title: state.isPasswordAvailable ? AppConstants.changePasswordStr : AppConstants.setPasswordStr,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.borderColor,
                ),
                body: Stack(
                  children: [
                    _mobileView(state: state),
                    state.loading ? const LoaderView() : const SizedBox.shrink(),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _mobileView({required ChangePasswordLoadedState state}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(visible: state.isPasswordAvailable == true, child: _currentPasswordWidget(state: state)),
          _newPasswordWidget(state: state),
          _confirmNewPasswordWidget(state: state),
          const Spacer(),
          _submitButton(state: state),
        ],
      ),
    );
  }

  Widget _currentPasswordWidget({required ChangePasswordLoadedState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(title: AppConstants.currentPasswordStr, textStyle: FontTypography.textFieldBlackStyle),
        AppTextField(
          maxLines: 1,
          height: 40,
          hintTxt: AppConstants.enterCurrentPasswordStr,
          textInputAction: TextInputAction.next,
          focusNode: _currentPasswordFocusNode,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_newPasswordFocusNode);
          },
          controller: currentPassTxtController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !state.showCurrentPassword,
          suffixIcon: InkWell(
            onTap: () {
              changePasswordCubit.onChangeCurrentPasswordVisibility();
            },
            child: Icon(
              state.showCurrentPassword ? Icons.visibility : Icons.visibility_off,
              size: 18.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _newPasswordWidget({required ChangePasswordLoadedState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(title: AppConstants.newPasswordStr, textStyle: FontTypography.textFieldBlackStyle),
        AppTextField(
          maxLines: 1,
          height: 40,
          hintTxt: AppConstants.enterNewPassStr,
          textInputAction: TextInputAction.next,
          focusNode: _newPasswordFocusNode,
          onEditingComplete: () {
            _currentPasswordFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
          },
          controller: newPassTxtController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !state.showNewPassword,
          suffixIcon: InkWell(
            onTap: () {
              changePasswordCubit.onChangeNewPasswordVisibility();
            },
            child: Icon(
              state.showNewPassword ? Icons.visibility : Icons.visibility_off,
              size: 18.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _confirmNewPasswordWidget({required ChangePasswordLoadedState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(title: AppConstants.confirmNewPasswordStr, textStyle: FontTypography.textFieldBlackStyle),
        AppTextField(
          maxLines: 1,
          height: 40,
          hintTxt: AppConstants.enterNewConfPassStr,
          textInputAction: TextInputAction.done,
          focusNode: _confirmPasswordFocusNode,
          onEditingComplete: () {
            _newPasswordFocusNode.unfocus();
            _confirmPasswordFocusNode.unfocus();
          },
          controller: confirmPassTxtController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !state.showConfirmPassword,
          suffixIcon: InkWell(
            onTap: () {
              changePasswordCubit.onChangeConfirmPasswordVisibility();
            },
            child: Icon(
              state.showConfirmPassword ? Icons.visibility : Icons.visibility_off,
              size: 18.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton({required ChangePasswordLoadedState state}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: AppButton(
        function: () {
          validateAndSubmitPassword(context, isPasswordAvailable:state.isPasswordAvailable);
        },
        title:  state.isPasswordAvailable ? AppConstants.changePasswordStr.toUpperCase() : AppConstants.setPasswordStr.toUpperCase(),
      ),
    );
  }



  void validateAndSubmitPassword(BuildContext context, {required bool isPasswordAvailable}) {
    if (isPasswordAvailable && currentPassTxtController.text.trim().isEmpty) {
      AppUtils.showSnackBar(AppConstants.plsEnterCurrentPassStr, SnackBarType.alert);
    } else if (newPassTxtController.text.trim().isEmpty) {
      AppUtils.showSnackBar(AppConstants.plsEnterNewPassStr, SnackBarType.alert);
    } else if (newPassTxtController.text.trim().length < 8) {
      AppUtils.showSnackBar(AppConstants.newPass8CharStr, SnackBarType.alert);
    } else if (!newPassTxtController.text.trim().isValidPassword()){
      AppUtils.showSnackBar(AppConstants.passwordSpecialChar, SnackBarType.alert);
    }else if (newPassTxtController.text.trim().isNotEmpty && confirmPassTxtController.text.trim().isEmpty) {
      AppUtils.showSnackBar(AppConstants.plsEnterConfNewPassStr, SnackBarType.alert);
    } else if (newPassTxtController.text.trim() != newPassTxtController.text.trim()) {
      AppUtils.showSnackBar(AppConstants.matchPasswordStr, SnackBarType.alert);
    }else if (!newPassTxtController.text.trim().isValidPassword()) {
      AppUtils.showSnackBar(AppConstants.passwordSpecialChar, SnackBarType.alert);
    } else if (confirmPassTxtController.text.trim().isEmpty) {
      AppUtils.showSnackBar(AppConstants.plsEnterConfNewPassStr, SnackBarType.alert);
    } else if (!confirmPassTxtController.text.trim().isValidPassword()) {
      AppUtils.showSnackBar(AppConstants.passwordSpecialChar, SnackBarType.alert);
    } else if (newPassTxtController.text.trim() != confirmPassTxtController.text.trim()) {
      AppUtils.showSnackBar(AppConstants.matchNewPasswordStr, SnackBarType.alert);
    } else if (isPasswordAvailable && currentPassTxtController.text.trim() == newPassTxtController.text.trim()) {
      AppUtils.showSnackBar(AppConstants.matchOldNewPassStr, SnackBarType.alert);
    } else {
      if (!isPasswordAvailable) {
        // Call Set Password method
        changePasswordCubit.onSetPasswordTap(
          context,
          newPassword: newPassTxtController.text,
          confirmPassword: confirmPassTxtController.text,
        );
      } else {
        // Call Change Password method
        changePasswordCubit.onChangePasswordTap(
          context,
          currentPassword: currentPassTxtController.text,
          newPassword: newPassTxtController.text,
          confirmPassword: confirmPassTxtController.text,
        );
      }
    }
  }
}
