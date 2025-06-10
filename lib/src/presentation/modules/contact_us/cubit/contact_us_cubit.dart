import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/modules/contact_us/cubit/contact_us_state.dart';
import 'package:workapp/src/presentation/modules/contact_us/repo/contact_us_repo.dart';
import 'package:workapp/src/utils/app_utils.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(ContactUsInitial());

  void init() async {
    emit(const ContactUsLoadedState());
  }

  ///called when clicking on set Password button when logged in from social media and password not set for api call
  Future<void> onSubmitTap(BuildContext context,
      {required String name,
      required String email,
      required String phoneNo,
      required String dialCode,
      required String countryCode,
      required String inquiryText}) async {
    var oldState = state as ContactUsLoadedState;
    try {
      emit(oldState.copyWith(loading: true));
      Map<String, dynamic> requestBody = {
        ModelKeys.firstName: AppUtils.loginUserModel?.firstName,
        ModelKeys.lastName: AppUtils.loginUserModel?.lastName,
        ModelKeys.email: email,
        ModelKeys.phoneCountryCode: countryCode,
        ModelKeys.phoneDialCode: dialCode,
        ModelKeys.phoneNumber: phoneNo,
        ModelKeys.enquiry: inquiryText,
      };

      var response =
          await ContactUsRepo.instance.onSubmitTap(context, json: requestBody);
      if (response?.status == true) {
        emit(oldState.copyWith(loading: false, data: response?.responseData));
        if (response?.message.isNullOrEmpty() == false) {
          AppRouter.pop(res: true);
          AppUtils.showSnackBar(response!.message, SnackBarType.success);
        }
      } else {
        emit(oldState.copyWith(loading: false));
        if (response?.message.isNullOrEmpty() == false) {
          AppUtils.showSnackBar(response!.message, SnackBarType.success);
        }
        AppUtils.showSnackBar(response!.message, SnackBarType.fail);
      }
    } catch (e) {
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
      emit(oldState.copyWith(loading: false));
    }
  }
}
