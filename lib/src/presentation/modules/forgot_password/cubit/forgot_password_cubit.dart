import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/forgot_password/repo/forgot_password_repo.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  Timer? otpTimer;

  ForgotPasswordCubit() : super(const ForgotPasswordInitial());

  void init() async {
    emit(const ForgotPasswordLoadedState());
    startTimer();
  }

  ///Used when clicking on send button on forgot password view
  Future<void> onSendClick(BuildContext context, {required String email, required bool isFromResend, required int otpType}) async {
    var oldState = state as ForgotPasswordLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.userName: email,
      };
      var response = await ForgotPasswordRepo.instance.forgotPassword(requestBody);

      if (response.status) {
        emit(oldState.copyWith(isLoading: false));
        if (isFromResend != true) {
          AppRouter.push(AppRoutes.emailVerificationScreenRoute, args: {
            ModelKeys.email: email,
            ModelKeys.otpType: otpType,
          });
        } else {
          init();
        }
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
    }
  }

  ///Used when clicking on resend button on forgot password view
  Future<void> resendEmailVerificationOtp(BuildContext context, {required String email}) async {
    var oldState = state as ForgotPasswordLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.userName: email,
        ModelKeys.type: 2,
      };
      var response = await ForgotPasswordRepo.instance.resendEmailVerificationOtp(requestBody);

      if (response.status) {
        emit(oldState.copyWith(isLoading: false));
        init();
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
    }
  }

  ///Used when clicking on send button on email verification view
  Future<void> onVerifySendClick(BuildContext context, {required String email, required String otpCode, required int otpType, required bool isFromSignUp, required bool isFromChangeEmail}) async {
    var oldState = state as ForgotPasswordLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.email: email,
        ModelKeys.otpCode: otpCode,
        ModelKeys.otpType: otpType,
      };

      var response = await ForgotPasswordRepo.instance.emailOTPVerification(requestBody);

      if (response.status) {
        emit(oldState.copyWith(isLoading: false));
        var token = response.responseData?.result?.resetPasswordToken;
        if (isFromSignUp) {
          LoginResponse savedData = await PreferenceHelper.instance.getUserData();
          await PreferenceHelper.instance.setUser(response.responseData);
          await PreferenceHelper.instance.setPreference(key: PreferenceHelper.isLogin, value: true);
          await PreferenceHelper.instance
              .rememberMe(savedData.result?.rememberMeEnabled ?? false, savedData.result?.password ?? '');
          AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
        } else {
          AppRouter.pushReplacement(AppRoutes.newPasswordScreenRoute, args: {ModelKeys.token: token});
        }
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
    }
  }

  ///For starting timer for resending otp if not able to receive email with otp code
  Future<void> startTimer() async {
    otpTimer?.cancel();
    int seconds = 60;
    otpTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      seconds--;
      var timerDisplay = seconds < 10 ? '00:0$seconds' : '00:$seconds';
      if (seconds == 0) {
        t.cancel();
      }
      updateTimer(time: timerDisplay);
    });
  }

  ///for displaying updated time left to expire otp on screen
  Future<void> updateTimer({required String time}) async {
    var oldState = state as ForgotPasswordLoadedState;
    emit(oldState.copyWith(timerDisplay: time));
  }

  ///Used when clicking on send button on email verification view
  Future<void> onEmailVerifySendClick(BuildContext context,
      {required String email,
      required String newEmail,
      required String otpCode,
      required int otpType,
      required bool isFromSignUp}) async {
    var oldState = state as ForgotPasswordLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.email: email,
        ModelKeys.newEmail: newEmail,
        ModelKeys.otpCode: otpCode,
        ModelKeys.otpType: otpType,
      };

      var response = await ForgotPasswordRepo.instance.emailChangeVerify(requestBody);

      if (response.status) {
        emit(oldState.copyWith(isLoading: false));
        await PreferenceHelper.instance.updateEmail(newEmail);
        AppRouter.pop(res: newEmail);
        AppRouter.pop(res: newEmail);
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
    }
  }

  Future<void> resendChangeEmailVerificationOtp(BuildContext context,
      {required String oldEmail, required String newEmail, required int otpType}) async {
    var oldState = state as ForgotPasswordLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));

      Map<String, dynamic> requestBody = {
        ModelKeys.oldEmail: oldEmail,
        ModelKeys.newEmail: newEmail,
        ModelKeys.type: EnumType.changeEmailOtpVerify,
      };

      var response = await ForgotPasswordRepo.instance.emailChangeOTPVerification(requestBody);

      if (response.status) {
        emit(oldState.copyWith(isLoading: false));
        init();
      } else {
        emit(oldState.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
    }
  }
}
