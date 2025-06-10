import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/contact_us/cubit/contact_us_cubit.dart';
import 'package:workapp/src/presentation/modules/contact_us/cubit/contact_us_state.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 05/12/24
/// @Message : [ContactUsView]
///
/// The `ContactUsScreen` provides interface for send enquire.
///
/// Responsibilities:
/// - Display contact us UI.
/// - Apply validation.
/// - Call api.
class ContactUsView extends StatefulWidget {
/*  final String name;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String phoneCode;*/

  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  ///ContactUsCubit initializing to call in bloc builder and calling cubit methods where need to manage state.
  ContactUsCubit contactUsCubit = ContactUsCubit();

  // name.
  final nameTxtController = TextEditingController();

  // email
  final emailTxtController = TextEditingController();

  // mobile
  final mobileTxtController = TextEditingController();

  // phone
  final phoneCodeController = TextEditingController();

  // country
  final countryCodeController = TextEditingController();

  // Inquiry Text
  final inquiryTextController = TextEditingController();

  // email
  final FocusNode _emailFocusNode = FocusNode();

  // mobile
  final FocusNode _mobileNoFocusNode = FocusNode();

  // password
  final FocusNode _passwordFocusNode = FocusNode();

  // inquiry focus
  final FocusNode _inquiryText = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      contactUsCubit.init();
      _loadUserData();
    });
    super.initState();
  }

  Future<void> _loadUserData() async {
    PreferenceHelper preferenceHelper = PreferenceHelper.instance;
    LoginResponse userData = await preferenceHelper.getUserData();
    var fullName = '${userData.result?.firstName} ${userData.result!.lastName}';
    nameTxtController.text = fullName;
    emailTxtController.text = userData.result?.email ?? emailTxtController.text;
    mobileTxtController.text = userData.result?.phoneNumber ?? mobileTxtController.text;
    phoneCodeController.text = userData.result?.phoneDialCode ?? phoneCodeController.text;
    countryCodeController.text = userData.result?.phoneCountryCode ?? countryCodeController.text;
    inquiryTextController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<ContactUsCubit, ContactUsState>(
          bloc: contactUsCubit,
          builder: (context, state) {
            if (state is ContactUsLoadedState) {
              return Scaffold(
                appBar: MyAppBar(
                  title: AppConstants.contactUs,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.borderColor,
                ),
                body: Stack(children: [_mobileView(state: state), state.loading ? const LoaderView() : const SizedBox.shrink()]),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _mobileView({required ContactUsLoadedState state}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox10Height(),
            _nameTextField(controller: nameTxtController, hintText: '${AppConstants.firstNameStr}*'),
            sizedBox10Height(),
            _emailTxtField(),
            sizedBox10Height(),
            IgnorePointer(
                ignoring: AppUtils.loginUserModel?.phoneNumber != null ? true : false,
                child: Opacity(
                  opacity: nameTxtController.text.isNotEmpty ? 0.7 : 1.0,
                  child: AppMobileTextField(
                    //isEnable: false,
                    focusNode: _mobileNoFocusNode,
                    onSubmitted: () {
                      _mobileNoFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    mobileTextEditController: mobileTxtController,
                    phoneCodeController: phoneCodeController,
                    countryCodeController: countryCodeController,
                  ),
                )),
            AppTextField(
              initialValue: null,
              hintTxt: AppConstants.enquireText,
              height: 130,
              maxLines: 6,
              topPadding: 12,
              textInputAction: TextInputAction.newline,
              controller: inquiryTextController,
              focusNode: _inquiryText,
            ),
            sizedBox30Height(),
            _buildSubmitBtn(state)
          ],
        ),
      ),
    );
  }

  /// AppButton used for sign in option and sign in as guest button where function is managed when in used and title
  /// managed as per need and bgColor to change button color if needed as we can see 2 buttons on screen with
  /// different colors and functions.
  Widget _buildSubmitBtn(ContactUsLoadedState state) {
    return AppButton(function: () => {onSubmitPress()}, title: AppConstants.submitStr);
  }

  ///when clicking on sign in app button this function is called where validation is managed and api call will be
  ///managed and if any error it will display snack bar for error type and if success it will redirect to home screen.
  Future<void> onSubmitPress() async {
    try {
      // Validate Name
      if (nameTxtController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyFirstStr, SnackBarType.alert);
        return;
      }

      // Validate Email
      if (emailTxtController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyEmailStr, SnackBarType.alert);
        return;
      }

      // Validate Mobile
      if (mobileTxtController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyMobileStr, SnackBarType.alert);
        return;
      }

      // Validate Phone
      if (countryCodeController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.emptyCountryCodeStr, SnackBarType.alert);
        return;
      }

      // Inquiry Text
      if (inquiryTextController.text.trim().isEmpty) {
        AppUtils.showSnackBar(AppConstants.inquiryText, SnackBarType.alert);
        return;
      }

      // Sign Up user if all fields are filled and verified
      await contactUsCubit.onSubmitTap(
        context,
        name: nameTxtController.text.trim(),
        email: emailTxtController.text.trim(),
        phoneNo: mobileTxtController.text.trim(),
        dialCode: phoneCodeController.text.trim(),
        countryCode: countryCodeController.text.trim(),
        inquiryText: inquiryTextController.text.trim(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('----$this---${e.toString()}');
      }
      AppUtils.showSnackBar(AppConstants.retryStr, SnackBarType.alert);
    }
  }

  ///custom common text field for common view for both first n last name with different text edit controller where we
  ///need to define when calling it and it is mandatory.
  Widget _nameTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Opacity(
      opacity: nameTxtController.text.isNotEmpty ? 0.7 : 1.0,
      child: AppTextField(
        hintTxt: hintText,
        keyboardType: TextInputType.text,
        controller: controller,
        isEnable: nameTxtController.text.isNotEmpty ? false : true,
        maxLines: 1,
        maxLength: 50,
        textInputAction: TextInputAction.next,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset(
            AssetPath.personIcon,
            fit: BoxFit.contain,
            height: 10.0,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  /// Email text-field where user has to enter it's registered email address for sign-up
  /// where value is passed in text edit controller (i.e. controller).
  /// it uses AppTextField which is custom designed text-field for the app and it is not mandatory.
  Widget _emailTxtField() {
    return Opacity(
      opacity: nameTxtController.text.isNotEmpty ? 0.7 : 1.0,
      child: AppTextField(
        isEnable: emailTxtController.text.isNotEmpty ? false : true,
        controller: emailTxtController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        hintTxt: AppConstants.enterEmailHintRequiredStr,
        focusNode: _emailFocusNode,
        textCapitalization: TextCapitalization.none,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset(
            AssetPath.emailIcon,
            fit: BoxFit.contain,
            height: 9.0,
            width: 9.0,
          ),
        ),
        onEditingComplete: () {},
      ),
    );
  }
}
