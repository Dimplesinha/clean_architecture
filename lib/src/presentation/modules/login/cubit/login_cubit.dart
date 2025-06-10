import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/repositories/auth_repo.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void init() async {
    emit(const LoginLoadedState());
  }

  void onIsRememberMe() async {
    var oldState = state as LoginLoadedState;
    try {
      emit(oldState.copyWith(isChecked: !oldState.isChecked));
    } catch (e) {
      emit(const LoginLoadedState());
    }
  }

  ///bool showPassword used to manage password for obscureText where using setState will change value of bool for
  ///displaying password
  void onShowPassword() async {
    var oldState = state as LoginLoadedState;
    try {
      emit(oldState.copyWith(showPassword: !oldState.showPassword));
    } catch (e) {
      emit(const LoginLoadedState());
    }
  }

  ///called when clicking on sign in button for api call and saving details in preference for future use.
  Future<void> onLoginTap(
    BuildContext context, {
    required String email,
    required String password,
    required int socialMediaType,
    required String socialMediaUserID,
    required String firstName,
    required String lastName,
    bool? rememberMe,
  }) async {
    var oldState = state as LoginLoadedState;
    try {
      emit(oldState.copyWith(loading: true));

      String? fcmToken = await PreferenceHelper.instance.getPreference(key: PreferenceHelper.fcmToken);

      int? deviceType;
      if (kIsWeb) {
        deviceType = 1; // Placeholder for web device ID management
      } else if (Platform.isIOS) {
        deviceType = 2; // Unique ID for iOS devices
      } else if (Platform.isAndroid) {
        deviceType = 3; // Unique ID for Android devices
      }
      Map<String, dynamic> requestBody = {
        ModelKeys.userName: email,
        ModelKeys.password: password,
        ModelKeys.deviceID: AppUtils.deviceUDID,
        ModelKeys.fcmToken: fcmToken,
        ModelKeys.deviceType: deviceType ?? 3,
        ModelKeys.socialMediaType: socialMediaType,
        ModelKeys.socialMediaUserId: socialMediaUserID,
      };

      var response = await AuthRepository.instance.login(requestBody);

      if (response.status) {
        emit(oldState.copyWith(loading: false));
        await PreferenceHelper.instance.setUser(response.responseData);
        await PreferenceHelper.instance.setPreference(key: PreferenceHelper.isLogin, value: true);
        await PreferenceHelper.instance.rememberMe(rememberMe ?? false, password);
        if (socialMediaUserID.isEmpty && response.responseData?.result?.otpVerified == false) {
          AppRouter.push(AppRoutes.emailVerificationScreenRoute, args: {
            ModelKeys.email: email,
            ModelKeys.otpType: EnumType.signUpPassword,
            ModelKeys.isFromSignUp: true,
            ModelKeys.password: password,
          });
        }

        /// If password reset from admin side then first reset new password
        else if (response.responseData?.result?.isTemporaryPassword == true) {
          AppRouter.push(AppRoutes.newPasswordScreenRoute, args: {ModelKeys.isForSetPassword: true});
        } else {
          AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
        }
      } else {
        /// If logged in using any social media and user doesn't exist then sign up the user
        if (socialMediaType != 1 && response.message == 'Email not found.') {
          emit(oldState.copyWith(loading: true));
          var latLongMap = await AppUtils.getLatLong();
          var locationDetails = await AppUtils.getLocationDetails();

          Map<String, dynamic> requestBody = {
            ModelKeys.currencyUUID: '00000000-0000-0000-0000-000000000000',
            ModelKeys.countryUUID: '00000000-0000-0000-0000-000000000000',
            ModelKeys.roleUUID: '00000000-0000-0000-0000-000000000000',
            ModelKeys.firstName: firstName,
            ModelKeys.lastName: lastName,
            ModelKeys.biography: '',
            ModelKeys.gender: '',
            ModelKeys.address: '',
            ModelKeys.city: locationDetails?.city ?? '',
            ModelKeys.state: locationDetails?.state ?? '',
            ModelKeys.country: locationDetails?.country ?? '',
            ModelKeys.email: email,
            ModelKeys.latitude: latLongMap[ModelKeys.latitude],
            ModelKeys.longitude: latLongMap[ModelKeys.longitude],
            ModelKeys.profilePic: '',
            ModelKeys.countryCode: '',
            ModelKeys.phoneNumber: '',
            ModelKeys.notificationType: 0,
            ModelKeys.profileVisibilityType: 1,
            ModelKeys.password: '',
            ModelKeys.deviceID: AppUtils.deviceUDID,
            ModelKeys.fcmToken: fcmToken,
            ModelKeys.deviceType: deviceType ?? 3,
            ModelKeys.socialMediaType: socialMediaType,
            ModelKeys.socialMediaUserId: socialMediaUserID,
            ModelKeys.otpVerified: false,
            ModelKeys.recordStatus: 1,
            ModelKeys.pushNotification: false,
            ModelKeys.emailNotification: false,
          };

          /// call sign up api to sign up through social media account
          var response = await AuthRepository.instance.signUp(requestBody);
          if (response.status) {
            emit(oldState.copyWith(loading: false));
            await PreferenceHelper.instance.setUser(response.responseData);

            await PreferenceHelper.instance.setPreference(key: PreferenceHelper.isLogin, value: true);
            if (email.isEmpty && response.responseData?.result?.otpVerified == false) {
              AppRouter.push(AppRoutes.emailVerificationScreenRoute, args: {
                ModelKeys.email: email,
                ModelKeys.otpType: EnumType.signUpPassword,
                ModelKeys.isFromSignUp: true,
              });
            } else {
              emit(oldState.copyWith(loading: false));
              AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
            }
          } else {
            emit(oldState.copyWith(loading: false));
            AppUtils.showSnackBar(response.message, SnackBarType.alert);
            AppRouter.push(AppRoutes.signUpScreenRoute, args: {
              ModelKeys.firstName: firstName,
              ModelKeys.lastName: lastName,
              ModelKeys.email: email,
              ModelKeys.socialMediaUserId: socialMediaUserID,
              ModelKeys.isFromSocialAuth: true
            });
          }
        } else {
          emit(oldState.copyWith(loading: false));

          AppUtils.showSnackBar(response.message, SnackBarType.alert);
        }
      }
    } catch (e) {
      emit(oldState.copyWith(loading: false));
    }
  }
}
