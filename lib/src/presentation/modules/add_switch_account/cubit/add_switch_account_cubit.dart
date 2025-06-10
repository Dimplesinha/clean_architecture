import 'dart:io';

import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/otp_verify_screen/view/otp_verify_view.dart';
import 'package:workapp/src/utils/signalr_helper.dart';

part 'add_switch_account_state.dart';

class AddSwitchAccountCubit extends Cubit<AddSwitchAccountLoadedState> {
  AddSwitchAccountCubit() : super(AddSwitchAccountLoadedState());

  void init() async {
    emit(state.copyWith(isInitialLoading: true));
    await getSubAccounts();
    emit(state.copyWith(isInitialLoading: false));
  }

  Future<void> getSubAccounts() async {
    try {
      emit(state.copyWith(isLoading: true));
      var response = await AddSwitchAccountRepository.instance.getSubAccount(path: ApiConstant.subAccount);
      if (response.status) {
        emit(state.copyWith(isLoading: false, subAccountModelResult: response.responseData?.result?.first));
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(state.copyWith(isLoading: false));
    }
  }

  void onCreateAccount() async {
    if (checkValidations()) {
      try {
        emit(state.copyWith(isLoading: true));
        Map<String, dynamic> requestBody = {
          ModelKeys.email: state.email,
          ModelKeys.password: state.password,
          ModelKeys.accountType: state.accountType,
          ModelKeys.deviceType:  Platform.isIOS ? AppPlatform.ios.value : AppPlatform.android.value
        };

        var response = await AddSwitchAccountRepository.instance
            .addSubAccount(path: ApiConstant.subAccount, requestBody: requestBody);

        if (response.status) {
          emit(state.copyWith(isLoading: false, addSwitchAccountResult: response.responseData));
          AppUtils.showSnackBar(response.message, SnackBarType.success);
        } else {
          AppUtils.showSnackBar(response.message, SnackBarType.fail);
          emit(state.copyWith(isLoading: false));
        }
      } catch (e) {
        AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  void onEmailChange({required String email}) {
    emit(state.copyWith(email: email));
  }

  void onPasswordChange({required String password}) {
    emit(state.copyWith(password: password));
  }

  void onConfirmPasswordChange({required String confirmPassword}) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void onAccountTypeChange({required int accountType}) {
    emit(state.copyWith(accountType: accountType));
  }

  void onAddAccount({required bool addAccount}) {
    emit(state.copyWith(addAccount: addAccount));
  }

  void onSwitchAccount({required SubAccountItems? selectedSwitchingAccount}) {
    state.selectedSwitchingAccount = selectedSwitchingAccount;
    emit(state.copyWith(selectedSwitchingAccount: state.selectedSwitchingAccount));
  }

  bool checkValidations() {
    bool isValidated = false;
    try {
      // Validate Account Type
      if (state.accountType == 0 || state.accountType == null) {
        AppUtils.showSnackBar(AppConstants.accountTypeStr, SnackBarType.alert, ct: bottomSheetKey.currentContext);
        return isValidated;
      }

      // Validate Email
      if (state.email?.isEmpty ?? true) {
        AppUtils.showSnackBar(AppConstants.emptyEmailStr, SnackBarType.alert, ct: bottomSheetKey.currentContext);
        return isValidated;
      } else if (!state.email.isValidEmail()) {
        AppUtils.showSnackBar(AppConstants.emailValidationStr, SnackBarType.alert, ct: bottomSheetKey.currentContext);
        return isValidated;
      }

      if (state.password?.isEmpty ?? true) {
        AppUtils.showSnackBar(AppConstants.pleaseEnterPasswordStr, SnackBarType.alert,
            ct: bottomSheetKey.currentContext);
        return isValidated;
      } else if ((state.password?.length ?? 0) < 8) {
        AppUtils.showSnackBar(AppConstants.password8Char, SnackBarType.alert, ct: bottomSheetKey.currentContext);
        return isValidated;
      } else if (!state.password.isValidPassword()) {
        AppUtils.showSnackBar(AppConstants.passwordSpecialChar, SnackBarType.alert, ct: bottomSheetKey.currentContext);
        return isValidated;
      }

      // Validate Confirm Password
      if ((state.password?.isNotEmpty ?? false) && (state.confirmPassword?.isEmpty ?? false)) {
        AppUtils.showSnackBar(AppConstants.plsEnterConfNewPassStr, SnackBarType.alert,
            ct: bottomSheetKey.currentContext);
        return isValidated;
      } else if (state.password != state.confirmPassword) {
        AppUtils.showSnackBar(AppConstants.matchPasswordStr, SnackBarType.alert, ct: bottomSheetKey.currentContext);
        return isValidated;
      }
      isValidated = true;
      return isValidated;
    } catch (e) {
      if (kDebugMode) {
        print('----$this---${e.toString()}');
      }
      AppUtils.showSnackBar(AppConstants.retryStr, SnackBarType.alert, ct: bottomSheetKey.currentContext);
      return false;
    }
  }

  void verifyAccountOnSwitch({
    required String email,
    required String uuid,
    bool? isFromSwitchAccount = false,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {ModelKeys.email: email};
      var response = await AddSwitchAccountRepository.instance
          .onVerifyAccount(path: ApiConstant.switchAccountOtpSend, requestBody: requestBody);
      if (response.status) {
        emit(state.copyWith(isLoading: false, addSwitchAccountResult: response.responseData));
        AppRouter.pushReplacement(
          AppRoutes.otpVerify,
          args: OtpVerifyScreen(
            email: email,
            userUUID: uuid,
            isFromSwitchAccount: isFromSwitchAccount,
          ),
        )?.then((result) {
          if (result == true && (isFromSwitchAccount ?? false)) {
            switchAccount(uuid: uuid, isFromSwitchAccount: isFromSwitchAccount);
          }
        });
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(state.copyWith(isLoading: false));
    }
  }

  void switchAccount({
    required String uuid,
    bool? isFromSwitchAccount = false,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {ModelKeys.switchUserId: uuid};

      var response = await AddSwitchAccountRepository.instance
          .onSwitchAccount(path: ApiConstant.switchAccount, requestBody: requestBody);

      if (response.status) {
        disconnectSignalR();
        PreferenceHelper preferenceHelper = PreferenceHelper.instance;

        /// If switch is successful then saving all the updated user details to preference
        preferenceHelper.setUser(response.responseData);

        /// Updating the utils also with latest details
        AppUtils.loginUserModel = response.responseData?.result;
        String accountType =
            AppUtils.loginUserModel?.accountTypeValue?.toLowerCase() == AppConstants.businessStr.toLowerCase()
                ? AppConstants.businessStr
                : AppConstants.personalStr;
        await PreferenceHelper.instance.updateAccountType(accountType);

        emit(state.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.success);
        if (!(isFromSwitchAccount ?? true)) {
          AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
        }
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(state.copyWith(isLoading: false));
    }
  }
  void onChangePasswordVisibility() {
    try {
      emit(state.copyWith(showPassword: !state.showPassword));
    } catch (e) {
      if (kDebugMode) {
        print('$this$e');
      }
    }
  }

  void onChangeNewPasswordVisibility() {
    try {
      emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
    } catch (e) {
      if (kDebugMode) {
        print('$this$e');
      }
    }
  }

  Future<void> disconnectSignalR() async {
    final SignalRHelper signalR = SignalRHelper.instance;
    await signalR.disconnect();
  }
}
