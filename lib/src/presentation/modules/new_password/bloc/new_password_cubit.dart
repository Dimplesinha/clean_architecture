import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/presentation/modules/new_password/repo/new_password_repo.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

part 'new_password_state.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  NewPasswordCubit() : super(NewPasswordInitial());

  void init() async {
    emit(NewPasswordLoadedState());
  }

  ///On show password for new password text-field password view
  void onShowPassword() async {
    var oldState = state as NewPasswordLoadedState;
    try {
      emit(oldState.copyWith(showPassword: !oldState.showPassword));
    } catch (e) {
      emit(NewPasswordLoadedState());
    }
  }

  ///On show password for confirm password text-field password view
  void onShowConfirmPassword() async {
    var oldState = state as NewPasswordLoadedState;
    try {
      emit(oldState.copyWith(showConfirmPassword: !oldState.showConfirmPassword));
    } catch (e) {
      emit(NewPasswordLoadedState());
    }
  }

  /// when clicked on submit it will call reset new password api
  Future<void> onSendClick(BuildContext context,
      {required String token, required String newPassword, required String confirmNewPassword}) async {
    var oldState = state as NewPasswordLoadedState;
    try {
      emit(oldState.copyWith(loading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.newPassword: newPassword,
        ModelKeys.confirmPassword: confirmNewPassword,
        ModelKeys.token: token,
      };

      var response = await NewPasswordRepo.instance.resetNewPassword(requestBody: requestBody);

      if (response.status) {
        emit(oldState.copyWith(loading: false));
        AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
      } else {
        emit(oldState.copyWith(loading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(loading: false));
    }
  }

  Future<void> onSetPassword(BuildContext context,
      {required String newPassword, required String confirmNewPassword}) async {
    var oldState = state as NewPasswordLoadedState;
    try {
      emit(oldState.copyWith(loading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.newPassword: newPassword,
        ModelKeys.confirmPassword: confirmNewPassword,
        ModelKeys.isResetPasswordByAdmin: true,
      };

      var response = await NewPasswordRepo.instance.setNewPassword(requestBody: requestBody);

      if (response.status) {
        emit(oldState.copyWith(loading: false));
        AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
      } else {
        emit(oldState.copyWith(loading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(loading: false));
    }
  }
}
