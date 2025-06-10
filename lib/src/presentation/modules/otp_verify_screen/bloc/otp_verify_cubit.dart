import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/modules/otp_verify_screen/repository/otp_verify_repository.dart';
import 'package:workapp/src/utils/utils.dart';

part 'otp_verify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyLoadedState> {
  Timer? otpTimer;

  OtpVerifyCubit() : super(const OtpVerifyLoadedState());

  void init() {
    startTimer();
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
    emit(state.copyWith(timerDisplay: time));
  }

  Future<void> resendOtp(BuildContext context, {required String email}) async {
    try {
      emit(state.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.userName: email,
        ModelKeys.type: EnumType.addSubAccountOtpVerify,
      };
      var response = await OtpVerifyRepository.instance.resendOtp(requestBody);
      if (response.status) {
        emit(state.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.success);
        init();
      } else {
        emit(state.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void verifyOtp({required String email, required String otp, required String userUUID}) async {
    try {
      emit(state.copyWith(isLoading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.email: email,
        ModelKeys.otpCode: otp,
        ModelKeys.otpType: EnumType.addSubAccountOtpVerify,
        ModelKeys.userUUID: userUUID,
      };

      var response = await OtpVerifyRepository.instance.otpVerification(requestBody);

      if (response.status) {
        emit(state.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.success);
        AppRouter.pop(res: true);
      } else {
        emit(state.copyWith(isLoading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
