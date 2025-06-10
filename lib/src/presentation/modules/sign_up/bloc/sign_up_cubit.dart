import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/models/country_all_listing_model.dart';
import 'package:workapp/src/domain/repositories/auth_repo.dart';
import 'package:workapp/src/utils/app_utils.dart';


part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  void init() async {
    emit(SignUpLoadedState());
  }

  ///bool showPassword used to manage password for obscureText where using setState will change value of bool for
  ///displaying password
  void onShowPassword() async {
    var oldState = state as SignUpLoadedState;
    try {
      emit(oldState.copyWith(showPassword: !oldState.showPassword));
    } catch (e) {
      emit(SignUpLoadedState());
    }
  }

  ///bool showConfirmPassword used to manage password for obscureText where using setState will change value of bool for
  ///displaying password
  void onShowConfirmPassword() async {
    var oldState = state as SignUpLoadedState;
    try {
      emit(oldState.copyWith(showConfirmPassword: !oldState.showConfirmPassword));
    } catch (e) {
      emit(SignUpLoadedState());
    }
  }

  /// to check terms and condition selected or not
  void onIsTermCondCheck() async {
    var oldState = state as SignUpLoadedState;
    try {
      emit(oldState.copyWith(isTNCChecked: !oldState.isTNCChecked));
    } catch (e) {
      emit(SignUpLoadedState());
    }
  }

  /// To select and show updated profile visibility
  void accountTypeChange(int value) async {
    var oldState = state as SignUpLoadedState;
    try {
      emit(oldState.copyWith(accountType: value));
    } catch (e) {
      emit(SignUpLoadedState());
    }
  }

  Future<void> selectedCountry({required String countryCode, required String countryPhoneCode}) async {
    var oldState = state as SignUpLoadedState;
    try {
      String flag = AppUtils.getFlag(countryCode);
      emit(oldState.copyWith(selectedFlag: flag, countryPhoneCode: countryPhoneCode));
      AppRouter.pop(res: true);
    } catch (e) {
      emit(oldState.copyWith());
    }
  }

  ///called when clicking on sign up  button for api call and saving details in preference for future use.
  Future<void> onSignUpTap(
    BuildContext context, {
    required String currencyUUID,
    required String countryUUID,
    required String firstName,
    required String lastName,
    required String email,
    required String biography,
    required String gender,
    required String address,
    required String city,
    required String profilePic,
    required String countryCode,
    required String phoneNumber,
    required int accountType,
    required String password,
    required int socialMediaType,
    required String socialMediaUserID,
    required String phoneCountryCode,
    required String phoneDialCode,
  }) async {
    var oldState = state as SignUpLoadedState;
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
      var latLongMap = await AppUtils.getLatLong();

      var locationDetails = await AppUtils.getLocationDetails();

      Map<String, dynamic> requestBody = {
        ModelKeys.currencyUUID: '00000000-0000-0000-0000-000000000000',
        ModelKeys.countryUUID: '00000000-0000-0000-0000-000000000000',
        ModelKeys.roleUUID: '00000000-0000-0000-0000-000000000000',
        ModelKeys.firstName: firstName,
        ModelKeys.lastName: lastName,
        ModelKeys.biography: biography,
        ModelKeys.gender: gender,
        ModelKeys.address:  '',
        ModelKeys.city: locationDetails?.city ?? '',
        ModelKeys.state: locationDetails?.state ?? '',
        ModelKeys.country: locationDetails?.country ?? '',
        ModelKeys.email: email,
        ModelKeys.latitude: latLongMap[ModelKeys.latitude],
        ModelKeys.longitude: latLongMap[ModelKeys.longitude],
        ModelKeys.profilePic: profilePic,
        ModelKeys.countryCode: countryCode,
        ModelKeys.phoneNumber: phoneNumber,
        ModelKeys.phoneCountryCode: phoneCountryCode, //phone country code
        ModelKeys.phoneDialCode: phoneDialCode, //phone dial code
        ModelKeys.notificationType: 0,
        ModelKeys.accountType: accountType,
        ModelKeys.password: password,
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

      var response = await AuthRepository.instance.signUp(requestBody);

      if (response.status) {
        emit(oldState.copyWith(loading: false));

        /// if sign up successful  and is not a social media sign up then navigate to email otp verification screen
        if (socialMediaUserID.isEmpty || response.responseData?.result?.otpVerified == false) {
          await AppRouter.pushReplacement(AppRoutes.emailVerificationScreenRoute, args: {
            ModelKeys.email: email,
            ModelKeys.otpType: EnumType.signUpPassword,
            ModelKeys.isFromSignUp: true,
          });
        }

        /// if from social sign then navigate to home screen
        else {
          await PreferenceHelper.instance.setUser(response.responseData);
          await PreferenceHelper.instance.setPreference(key: PreferenceHelper.isLogin, value: true);
          await AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
        }
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      } else {
        /// if sign up from social media account and user already exist then sign in user and navigate to home screen
        if (socialMediaType != 1 && response.message == 'User already exists ') {
          await handleExistingUserLogin(context, email: email, password: password, socialMediaType: socialMediaType, socialMediaUserID: socialMediaUserID, deviceType: deviceType, fcmToken: fcmToken, firstName: firstName, lastName: lastName, profilePic: profilePic);
        }
        emit(oldState.copyWith(loading: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      emit(oldState.copyWith(loading: false));
    }
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
    var oldState = state as SignUpLoadedState;
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
      Map<String, dynamic> loginRequestBody = {
        ModelKeys.userName: email,
        ModelKeys.password: password,
        ModelKeys.deviceID: AppUtils.deviceUDID,
        ModelKeys.fcmToken: fcmToken,
        ModelKeys.deviceType: deviceType ?? 3,
        ModelKeys.socialMediaType: socialMediaType,
        ModelKeys.socialMediaUserId: socialMediaUserID,
      };

      var loginResponse = await AuthRepository.instance.login(loginRequestBody);
      if (loginResponse.status) {
        emit(oldState.copyWith(loading: false));

        await PreferenceHelper.instance.setUser(loginResponse.responseData);

        await PreferenceHelper.instance.setPreference(key: PreferenceHelper.isLogin, value: true);
        await AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
      } else {
        emit(oldState.copyWith(loading: false));

        /// if email id does not exist then sign up user , in case if email is empty fill form then
        if (loginResponse.message == 'Email not found.' && email.isNotEmpty) {
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
            ModelKeys.address:'',
            ModelKeys.city: locationDetails?.city ?? '',
            ModelKeys.state: locationDetails?.state ?? '',
            ModelKeys.country:locationDetails?.country ?? '',
            ModelKeys.email: email,
            ModelKeys.latitude: latLongMap[ModelKeys.latitude],
            ModelKeys.longitude: latLongMap[ModelKeys.latitude],
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
            AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
          } else {
            emit(oldState.copyWith(loading: false));
            AppUtils.showSnackBar(response.message, SnackBarType.alert);
          }
        }
        AppUtils.showSnackBar(loginResponse.message, SnackBarType.alert);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// to hide password field if its from social auth
  void setGoogleSignUp(bool isFromGoogleAuth) {
    var oldState = state as SignUpLoadedState;
    try {
      emit(oldState.copyWith(isFromGoogleAuth: isFromGoogleAuth));
    } catch (e) {
      emit(oldState.copyWith(loading: false));
    }
  }
}
