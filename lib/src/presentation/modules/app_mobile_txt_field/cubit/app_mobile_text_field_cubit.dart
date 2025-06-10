import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/models/country_all_listing_model.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/countries.dart';
import 'package:workapp/src/utils/country_list.dart';
import 'package:workapp/src/utils/date_time_utils.dart';

part 'app_mobile_text_field_state.dart';

class AppMobileTextFieldCubit extends Cubit<AppMobileTextFieldState> {
  AppMobileTextFieldCubit() : super(AppMobileTextFieldInitial());

  String? phoneDialCode;

  String? countryCode;

  void init(String mobileNumber, String phoneDialCode, String countryCode) async {
    this.phoneDialCode = phoneDialCode;
    this.countryCode = countryCode;
    emit(AppMobileTextFiledLoadedState());
    countryAPICall(mobileNumber);
  }

  Future<void> countryAPICall(String mobileNumber) async {
    try {
      var countryData = await PreferenceHelper.instance.getCountryList();
      if (countryData.result != null) {
        DateTime currentDate = DateTime.now();
        String currentFormattedDate = DateTimeUtils.instance.timeStampToDateOnly(currentDate);
        if (countryData.getCountryLoadedDate() != currentFormattedDate) {
          await MasterDataAPI.getCountries();
        } else {
          await PreferenceHelper.instance.getCountryList();
        }
      } else {
        await MasterDataAPI.getCountries();
      }
      await fetchAllCountry(mobileNumber);
    } catch (e) {
      if (kDebugMode) {
        print('--$this---print-----   ${e.toString()}');
      }
    }
  }

  /// Fetch all Country
  Future<void> fetchAllCountry(String mobileNumber) async {
    String countryCode = '';
    String phoneCode = '';
    String flag = '';
    String numberOnly = '';
    AppMobileTextFiledLoadedState oldState;

    if (mobileNumber.isNotEmpty && phoneDialCode != null) {
      phoneCode = phoneDialCode ?? '';
      countryCode = this.countryCode ?? '';
      flag = AppUtils.getFlag(countryCode);
      var country = myCountryList.where((element) {
        return element.code == countryCode;
      }).toList();
      int maxLength = country.isNotEmpty ? country.first.maxLength : 10;
      oldState = state as AppMobileTextFiledLoadedState;

      emit(oldState.copyWith(maxLength: maxLength));
    } else if (mobileNumber.isNotEmpty && mobileNumber.contains('+')) {
      final regex = RegExp(r'(\+\d{1,2})(\d+)');
      Match? match = regex.firstMatch(mobileNumber);
      if (match != null) {
        countryCode = match.group(1) ?? '';
        numberOnly = match.group(2) ?? '';
      }
      phoneCode = countryCode.replaceAll('+', '');
      countryCode = this.countryCode ?? '';
      flag = AppUtils.getFlag(countryCode);

      var country = myCountryList.where((element) => element.code == countryCode).toList().first;

      oldState = state as AppMobileTextFiledLoadedState;
      emit(oldState.copyWith(maxLength: country.maxLength));
    } else {
      countryCode = await AppUtils.getCountry();
      flag = AppUtils.getFlag(countryCode);
      phoneCode = countryList
          .firstWhere((element) => element.isoCode == countryCode, orElse: () => countryList.first)
          .phoneCode;
      phoneCode = '+$phoneCode';
      var country = myCountryList
          .where((element) {
            return element.code == countryCode;
          })
          .toList()
          .first;
      oldState = state as AppMobileTextFiledLoadedState;
      emit(oldState.copyWith(maxLength: country.maxLength));
    }
    try {
      var response = await PreferenceHelper.instance.getCountryList();

      if (response.statusCode == 200 && response.result != null) {
        var oldState = state as AppMobileTextFiledLoadedState;
        emit(oldState.copyWith(
          countryListing: response.result,
          selectedFlag: flag,
          countryPhoneCode: phoneCode,
          mobileNumber: numberOnly,
          countryCode: countryCode,
        ));
      } else {
        oldState = state as AppMobileTextFiledLoadedState;
        emit(oldState.copyWith(
            countryListing: response.result ?? [],
            selectedFlag: flag,
            countryPhoneCode: phoneCode,
            mobileNumber: numberOnly,
            countryCode: countryCode));
      }
    } catch (e) {
      oldState = state as AppMobileTextFiledLoadedState;
      emit(oldState.copyWith(
        countryListing: [],
        selectedFlag: flag,
        countryPhoneCode: phoneCode,
        countryCode: countryCode,
      ));
    }
  }

  Future<void> selectedCountry({required String countryCode, required String countryPhoneCode}) async {
    var oldState = state as AppMobileTextFiledLoadedState;
    try {
      String flag = AppUtils.getFlag(countryCode);
      var country = myCountryList
          .where((element) {
            return element.code == countryCode;
          })
          .toList()
          .first;
      emit(oldState.copyWith(
        selectedFlag: flag,
        countryPhoneCode: '+$countryPhoneCode',
        countryCode: countryCode,
        maxLength: country.maxLength,
      ));
      AppRouter.pop(res: true);
    } catch (e) {
      AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.alert);
    }
  }
}
