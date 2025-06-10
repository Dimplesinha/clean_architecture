import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/radio_button_widget.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_regex.dart';
import 'package:workapp/src/utils/app_utils.dart';

class PromoContactDetailsFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const PromoContactDetailsFormView(
      {super.key, required this.addListingFormCubit, required this.state,});

  @override
  State<PromoContactDetailsFormView> createState() => _PromoContactDetailsFormViewState();
}

class _PromoContactDetailsFormViewState extends State<PromoContactDetailsFormView> {
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();

  @override
  void initState() {
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.businessPhone] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneCountryCode] ?? '';
    widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {AddListingFormConstants.listingVisibility: DropDownConstants.countrywide},);
    super.initState();
  }

  void handleShowStreetAddress() {
    if (widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false) {
      RequiredFieldsConstants.promoContactDetailsRequiredFields =
          RequiredFieldsConstants.promoContactDetailsRequiredFields
            ..addAll(
              {AddListingFormConstants.showStreetAddress: null},
            );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.showStreetAddress, value: '');
      RequiredFieldsConstants.promoContactDetailsRequiredFields =
          RequiredFieldsConstants.promoContactDetailsRequiredFields
            ..remove(
              AddListingFormConstants.showStreetAddress,
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            title: AddListingFormConstants.contactName,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.contactName,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.contactName],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.contactName, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.contactPhone,
            isRequired: false,
            textStyle: FontTypography.subTextStyle,
          ),
          AppMobileTextField(
            mobileTextEditController: mobileTxtController,
            phoneCodeController: phoneCodeController,
            countryCodeController: countryCodeController,
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessPhone, value: value);
            },
            onPhoneCountryChanged: (String countryCode, String countryPhoneCode, bool isApply) {
              if (isApply) mobileTxtController.text = '';
              countryCodeController.text = countryCode;
              phoneCodeController.text = countryPhoneCode;

              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.phoneDialCode,
                value: phoneCodeController.text,
              );
              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.countryCode,
                value: countryCode,
              );
              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.phoneCountryCode,
                value: countryCodeController.text,
              );
            },
          ),
          LabelText(
            title: AddListingFormConstants.contactEmail,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.enterBusinessEmail,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.contactEmail],
            onChanged: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.contactEmail, value: value.trim());
            },
          ),
          Visibility(
            visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
            child: LabelText(
              title: AddListingFormConstants.enterYourWebsite,
              isRequired: false,
              textStyle: FontTypography.subTextStyle,
            ),
          ),
          Visibility(
            visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
            child: AppTextField(
              textCapitalization: TextCapitalization.none,
              hintTxt: AddListingFormConstants.enterBusinessWebsite,
              initialValue: widget.state.formDataMap?[AddListingFormConstants.businessWebsite],
              onChanged: (value) {
                widget.addListingFormCubit.onFieldsValueChanged(
                  key: AddListingFormConstants.businessWebsite,
                  value: value,
                );
                handleBusinessWebsite();
              },
            ),
          ),
          LabelText(
            title: AddListingFormConstants.streetAddress,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.enterStreetAddress,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.streetAddress],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.streetAddress, value: value);
              handleShowStreetAddress();
            },
          ),
          LabelText(
            title: AddListingFormConstants.cityAndCountry,
            textStyle: FontTypography.subTextStyle,
          ),
          GoogleLocationView(
            selectedLocation: widget.state.formDataMap?[AddListingFormConstants.location],
            onLocationChanged: (Map<String, String?>? json) {
              // Extract city, state, and country based on the number of parts available
              String? city;
              String? state;
              String? country;
              String? location;
              if (json != null) {
                try {
                  city = json[ModelKeys.city];
                  state = json[ModelKeys.administrativeAreaLevel_1];
                  country = json[ModelKeys.country];
                  location = json[ModelKeys.description];
                  widget.addListingFormCubit.latitude = double.parse(json[ModelKeys.latitudeGoogleApi] ?? '0.0');
                  widget.addListingFormCubit.longitude = double.parse(json[ModelKeys.longitudeGoogleApi] ?? '0.0');

                  // Update form fields with extracted values
                } catch (e) {
                  if (kDebugMode) print('_ContactDetailsFormViewState.build-->${e.toString()}');
                }
              } else {
                widget.addListingFormCubit.latitude = 0.0;
                widget.addListingFormCubit.longitude = 0.0;
              }

              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.latitude,
                value: widget.addListingFormCubit.latitude.toString(),
              );

              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.longitude,
                value: widget.addListingFormCubit.longitude.toString(),
              );

              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.location,
                value: location,
              );
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.city, value: city);
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.state, value: state);
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.country, value: country);
            },
          ),
          Visibility(
            visible: widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false,
            child: LabelText(
              title: AddListingFormConstants.showStreetAddress,
              textStyle: FontTypography.subTextStyle,
            ),
          ),
          Visibility(
            visible: widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false,
            child: Row(
              children: [
                RadioButtonWidget(
                  state: widget.state,
                  formConstantKey: AddListingFormConstants.showStreetAddress,
                  addListingFormCubit: widget.addListingFormCubit,
                  title: AddListingFormConstants.yes,
                ),
                sizedBox29Width(),
                RadioButtonWidget(
                  state: widget.state,
                  formConstantKey: AddListingFormConstants.showStreetAddress,
                  addListingFormCubit: widget.addListingFormCubit,
                  title: AddListingFormConstants.no,
                ),
              ],
            ),
          ),
          LabelText(
            title: AddListingFormConstants.visibility,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            hintText: AddListingFormConstants.selectVisibility,
            items: DropDownConstants.visibilityDropDownListWithLocal.values.toList(),
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
            dropDownOnChange: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.listingVisibility, value: value ?? '');
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mobileTxtController.dispose();
    phoneCodeController.dispose();
    countryCodeController.dispose();
    super.dispose();
  }
  void handleBusinessWebsite() {
    if (widget.state.formDataMap?.containsKey(AddListingFormConstants.businessWebsite) ?? false) {
      RequiredFieldsConstants.promoContactDetailsRequiredFields = RequiredFieldsConstants.promoContactDetailsRequiredFields
        ..addAll(
          {
            AddListingFormConstants.businessWebsite: FormValidationRegex.websiteRegex,
          },
        );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: '');
      RequiredFieldsConstants.promoContactDetailsRequiredFields = RequiredFieldsConstants.promoContactDetailsRequiredFields
        ..remove(
          AddListingFormConstants.businessWebsite,
        );
    }
  }

}
