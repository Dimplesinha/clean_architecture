import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/presentation/modules/settings/cubit/settings_state.dart';
import 'package:workapp/src/presentation/modules/settings/repo/settings_repo.dart';
import 'package:workapp/src/utils/app_utils.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  void init() async {
    emit(SettingsLoadedState());
    getUserData();
  }

  /// handle user login in case of social media account
  Future<void> handleExistingUserLogin(
    BuildContext context, {
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String profilePic,
    int? deviceType,
    String? fcmToken,
    required int socialMediaType,
    required String socialMediaUserID,
  }) async {
    var oldState = state as SettingsLoadedState;
    var data = await PreferenceHelper.instance.getUserData();

    try {
      emit(oldState.copyWith(loading: true, loginResponse: data));
      // call sign up api to sign up through social media account
      Map<String, dynamic> requestBody = {
        ModelKeys.socialMediaType: socialMediaType,
        ModelKeys.socialMediaUserId: socialMediaUserID,
      };
      var response = await SettingsRepo.instance.onLinkAccountTap(context: context, json: requestBody);
      if (response!.status) {
        emit(oldState.copyWith(loading: false));
        await PreferenceHelper.instance.setUser(response.responseData);
        await AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
        AppUtils.showSnackBar(response.message, SnackBarType.success);
      } else {
        emit(oldState.copyWith(loading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(loading: false));
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Get user data from preferences.
  Future<void> getUserData() async {
    var oldState = state as SettingsLoadedState;
    var data = await PreferenceHelper.instance.getUserData();
    emit(oldState.copyWith(loading: false, loginResponse: data));
  }
}
