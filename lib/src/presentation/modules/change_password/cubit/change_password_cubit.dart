import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/core/routes/routing.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/models/login_model.dart';
import 'package:workapp/src/domain/repositories/auth_repo.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/change_password/repo/change_password_repo.dart';
import 'package:workapp/src/utils/app_utils.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepo changePasswordRepo;

  ChangePasswordCubit({required this.changePasswordRepo}) : super(ChangePasswordInitial());

  void init() async {
    bool isPasswordAvailable = AppUtils.loginUserModel?.isPasswordAvailable ?? false;
    emit(ChangePasswordLoadedState(isPasswordAvailable: isPasswordAvailable));
  }

  void onChangeCurrentPasswordVisibility() {
    var oldState = state as ChangePasswordLoadedState;
    try {
      emit(oldState.copyWith(
        showCurrentPassword: !oldState.showCurrentPassword,
      ));
    } catch (e) {
      if (kDebugMode) {
        print('$this$e');
      }
    }
  }

  void onChangeNewPasswordVisibility() {
    var oldState = state as ChangePasswordLoadedState;
    try {
      emit(oldState.copyWith(showNewPassword: !oldState.showNewPassword));
    } catch (e) {
      if (kDebugMode) {
        print('$this$e');
      }
    }
  }

  void onChangeConfirmPasswordVisibility() {
    var oldState = state as ChangePasswordLoadedState;
    try {
      emit(oldState.copyWith(showConfirmPassword: !oldState.showConfirmPassword));
    } catch (e) {
      if (kDebugMode) {
        print('$this$e');
      }
    }
  }

  ///called when clicking on change Password button for api call
  Future<void> onChangePasswordTap(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    var oldState = state as ChangePasswordLoadedState;
    PreferenceHelper preferenceHelper = PreferenceHelper.instance;
    LoginResponse user = await preferenceHelper.getUserData();
    String? uuid = user.result?.uuid;
    try {
      emit(oldState.copyWith(loading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.uuid: uuid,
        ModelKeys.currentPassword: currentPassword,
        ModelKeys.newPassword: newPassword,
        ModelKeys.confirmPassword: confirmPassword,
      };

      var response = await changePasswordRepo.changePassword(requestBody);

      if (response.status) {
        emit(oldState.copyWith(loading: false));
        var logout = await AuthRepository.instance.logout();

        navigatorKey.currentState?.pop();

        AppUtils.showSnackBar(response.message, SnackBarType.success);

        if (logout.status) {
          // Navigate to sign-in screen and remove all other routes
          AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
        }
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(loading: false));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loading: false));
    }
  }

  ///called when clicking on set Password button when logged in from social media and password not set for api call
  Future<void> onSetPasswordTap(
    BuildContext context, {
    required String newPassword,
    required String confirmPassword,
  }) async {
    var oldState = state as ChangePasswordLoadedState;
    try {
      emit(oldState.copyWith(loading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.newPassword: newPassword,
        ModelKeys.confirmPassword: confirmPassword,
      };

      var response = await changePasswordRepo.setPassword(requestBody);

      if (response.status) {
        emit(oldState.copyWith(loading: false));
        await PreferenceHelper.instance.updateData(true);
        AppUtils.loginUserModel?.isPasswordAvailable = true;
        AppRouter.pop(res: true);
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(loading: false));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loading: false));
    }
  }
}
