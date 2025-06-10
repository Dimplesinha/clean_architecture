import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/dashboard/bloc/dashboard_cubit.dart';
import 'package:workapp/src/presentation/modules/dashboard/repo/dashboard_repo.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/countries.dart';

part 'profile_personal_details_state.dart';

class ProfilePersonalDetailsCubit extends Cubit<ProfilePersonalDetailsState> {
  ProfilePersonalDetailsRepo profilePersonalDetailsRepo;
  DashboardCubit dashboardCubit = DashboardCubit(dashboardRepository: DashboardRepository.instance);

  ProfilePersonalDetailsCubit({required this.profilePersonalDetailsRepo}) : super(ProfilePersonalDetailsInitial());

  void init() async {
    try {
      emit(ProfilePersonalDetailsLoaded(loader: true));
      var response = await profilePersonalDetailsRepo.getProfilePersonalDetails();

      var oldState = state as ProfilePersonalDetailsLoaded;
      log(' response.responseData:${response.responseData}');
      emit(oldState.copyWith(
        loader: false,
        profilePersonalDetailsModel: response.responseData,
      ));
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  void onEditButtonClicked() {
    var oldState = state as ProfilePersonalDetailsLoaded;
    emit(oldState.copyWith(
      isEditingProfile: !oldState.isEditingProfile,
      isFromBasicDetails: !oldState.isFromBasicDetails,
      profilePersonalDetailsModel: oldState.profilePersonalDetailsModel,
    ));
  }

  void onApplyButtonClicked(LoginModel profilePersonalDetailsModel) {
    var oldState = state as ProfilePersonalDetailsLoaded;

    emit(oldState.copyWith(
      isEditingProfile: !oldState.isEditingProfile,
      profilePersonalDetailsModel: profilePersonalDetailsModel,
    ));
  }

  void onNotificationChanged(String? notification) {
    var oldState = state as ProfilePersonalDetailsLoaded;

    // Define initial values for pushNotification and emailNotification
    bool pushNotification = false;
    bool emailNotification = false;

    // Set the values based on the selected notification
    if (notification == 'Email') {
      pushNotification = false;
      emailNotification = true;
    } else if (notification == 'Mobile') {
      pushNotification = true;
      emailNotification = false;
    } else if (notification == 'Both') {
      pushNotification = true;
      emailNotification = true;
    }

    // Emit the updated state with the selected notification and updated fields
    emit(oldState.copyWith(
      selectedNotification: notification,
      pushNotification: pushNotification,
      emailNotification: emailNotification,
    ));
  }

  void onSetPassword(bool? isPasswordAvailable) {
    var oldState = state as ProfilePersonalDetailsLoaded;
    emit(oldState.copyWith(isPasswordAvailable: isPasswordAvailable));
  }

  /// Fetch all Country
  Future<void> fetchAllCountry() async {
    var oldState = state as ProfilePersonalDetailsLoaded;
    String cleanedPhoneCode = oldState.countryPhoneCode?.replaceAll('+', '') ?? '';

    String? countryCode = getIsoCodeByPhoneCode(cleanedPhoneCode);
    String flag = AppUtils.getFlag(countryCode ?? 'US');

    try {
      emit(oldState.copyWith(loader: true));

      var response = await PreferenceHelper.instance.getCountryList();

      if (response.statusCode == 200 && response.result != null) {
        emit(oldState.copyWith(
            countryListing: response.result, selectedFlag: flag, loader: false, countryPhoneCode: cleanedPhoneCode));
      } else {
        emit(oldState.copyWith(
          countryListing: response.result ?? [],
          loader: false,
          selectedFlag: flag,
        ));
      }
    } catch (e) {
      emit(oldState.copyWith(
        countryListing: [],
        loader: false,
        selectedFlag: flag,
      ));
    }
  }

  Future<void> selectedCountry({required String countryCode, required String countryPhoneCode}) async {
    var oldState = state as ProfilePersonalDetailsLoaded;
    try {
      String flag = AppUtils.getFlag(countryCode);
      emit(oldState.copyWith(selectedFlag: flag, countryPhoneCode: countryPhoneCode));
      AppRouter.pop(res: true);
    } catch (e) {
      emit(oldState.copyWith());
    }
  }

  String? getIsoCodeByPhoneCode(String phoneCode) {
    for (var country in countryList) {
      if (country.phoneCode == phoneCode) {
        return country.isoCode; // Return the ISO code if found
      }
    }
    return null; // Return null if no matching country is found
  }

  Future<void> separateCountryCode(String phoneNumber) async {
    var oldState = state as ProfilePersonalDetailsLoaded;

    try {
      // Regular expression to capture country code and number
      final regex = RegExp(r'(\+\d{1,2})(\d+)');
      Match? match = regex.firstMatch(phoneNumber);

      if (match != null) {
        String countryCode = match.group(1) ?? '';
        String number = match.group(2) ?? '';

        emit(oldState.copyWith(countryPhoneCode: countryCode, mobileNumber: number));
      } else {
        emit(oldState.copyWith());
      }
    } catch (e) {
      emit(oldState.copyWith());
    }
  }

  Future<void> onSubmitTap(
    BuildContext context, {
    required String currencyUUID,
    required String countryUUID,
    required String firstName,
    required String lastName,
    required int birthYear,
    required String gender,
    required String address,
    required String city,
    required String location,
    required String states,
    required String country,
    required String email,
    required String profilePic,
    required String countryCode,
    required String accountTypeValue,
    required String phoneNumber,
    required bool emailNotification,
    required bool pushNotification,
    required bool isFromProfile,
    required String phoneDialCode,
    required String phoneCountryCode,
  }) async {
    var oldState = state as ProfilePersonalDetailsLoaded;
    try {
      emit(oldState.copyWith(loader: true));
      var latLongMap = await AppUtils.getLatLong();

      Map<String, dynamic> requestBody = {
        ModelKeys.uuid: AppUtils.loginUserModel?.uuid ?? '',
        ModelKeys.firstName: firstName,
        ModelKeys.lastName: lastName,
        ModelKeys.birthYear: birthYear,
        ModelKeys.gender: gender,
        ModelKeys.address: address,
        ModelKeys.city: city,
        ModelKeys.state: states,
        ModelKeys.country: country,
        ModelKeys.email: email,
        ModelKeys.latitude: latLongMap[ModelKeys.latitude],
        ModelKeys.longitude: latLongMap[ModelKeys.longitude],
        ModelKeys.accountType: AppUtils.getAccountType(accountTypeValue),
        ModelKeys.phoneCountryCode: phoneCountryCode.toLowerCase(),
        ModelKeys.countryCode: phoneCountryCode,
        ModelKeys.phoneNumber: phoneNumber,
        ModelKeys.recordStatus: 1,
        ModelKeys.location: location,
        ModelKeys.pushNotification: pushNotification,
        ModelKeys.emailNotification: emailNotification,
        ModelKeys.phoneDialCode: phoneDialCode,
        ModelKeys.phoneCountryCode: phoneCountryCode,
      };

      var response = await ProfilePersonalDetailsRepo.instance.updateProfile(requestBody);
      if (response.status) {
        oldState.copyWith(loader: false);
        LoginModel updatedUserData = LoginModel(
          firstName: firstName,
          lastName: lastName,
          birthYear: birthYear,
          gender: gender,
          address: address,
          city: city,
          dialCode: countryCode,
          state: states,
          countryName: country,
          email: email,
          accountType: AppUtils.getAccountType(accountTypeValue),
          phoneNumber: phoneNumber,
          pushNotification: pushNotification,
          emailNotification: emailNotification,
          phoneDialCode: phoneDialCode,
          phoneCountryCode: phoneCountryCode,
          location: city,
          profilepic: profilePic,
        );

        await PreferenceHelper.instance.updatedUserData(updatedUserData);

        if (isFromProfile == false) {
          AppRouter.pop(res: true);
        }
        AppRouter.pop(res: true);
        AppUtils.showSnackBar(response.message, SnackBarType.success);
        // dashboardCubit.init();
        await dashboardCubit.fetchAllCategories();
        dashboardCubit.currentPage = 1;
        await dashboardCubit.fetchItems(
          visibilityTypeName: AppConstants.myCountryStr,
          isFromChangedCategory: true,
          isRefresh: true,
          isFromInitialCall: false,
        );
      } else {
        emit(oldState.copyWith(loader: false));
        AppUtils.showSnackBar(response.message, SnackBarType.alert);
      }
    } catch (e) {
      if (kDebugMode) {
        print('----$this---$e');
      }
      emit(oldState.copyWith(loader: false));
    }
  }

  void onCancelButtonClicked() {
    var oldState = state as ProfilePersonalDetailsLoaded;
    emit(oldState.copyWith(
      isEditingProfile: !oldState.isEditingProfile,
      selectedNotification: '',
    ));
  }

  /// show snackBar and hide it after 3 sec
  void showCustomSnackBar() {
    var oldState = state as ProfilePersonalDetailsLoaded;
    emit(oldState.copyWith(
      showSnackBar: true,
    ));
    Future.delayed(const Duration(seconds: 3)).then((value) {
      var oldState = state as ProfilePersonalDetailsLoaded;
      emit(oldState.copyWith(
        showSnackBar: false,
      ));
    });
  }

  void onSetEmail(String? email) {
    var oldState = state as ProfilePersonalDetailsLoaded;
    emit(oldState.copyWith(email: email));
  }

  Future<void> onChangeEmailTap(
    BuildContext context, {
    required String email,
    required String newEmail,
    required String confirmedEmail,
    required String password,
  }) async {
    var oldState = state as ProfilePersonalDetailsLoaded;
    PreferenceHelper preferenceHelper = PreferenceHelper.instance;
    LoginResponse user = await preferenceHelper.getUserData();
    String? email = user.result?.email;
    try {
      emit(oldState.copyWith(loader: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.email: email,
        ModelKeys.newEmail: newEmail,
        ModelKeys.confirmedEmail: confirmedEmail,
        ModelKeys.password: password,
      };

      var response = await profilePersonalDetailsRepo.changeEmail(requestBody);

      if (response.status) {
        emit(oldState.copyWith(loader: false));
        AppRouter.push(AppRoutes.emailVerificationScreenRoute, args: {
          ModelKeys.isFromChangeEmail: true,
          ModelKeys.otpType: EnumType.changeEmailOtpVerify,
          ModelKeys.email: email,
          ModelKeys.newEmail: newEmail,
        })?.then((result) {
          if (result == true) {
            onSetEmail(newEmail);
          }
        });
      } else {
        AppRouter.pop();
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
        emit(oldState.copyWith(loader: false));
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loader: false));
    }
  }
}
