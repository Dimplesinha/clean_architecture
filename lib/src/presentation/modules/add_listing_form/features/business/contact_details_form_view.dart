import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_regex.dart';

class ContactDetailsFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const ContactDetailsFormView({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<ContactDetailsFormView> createState() => _ContactDetailsFormViewState();
}

class _ContactDetailsFormViewState extends State<ContactDetailsFormView> {
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();

  @override
  void initState() {
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.businessPhone] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneCountryCode] ?? '';
    if (widget.state.formDataMap?.containsKey(AddListingFormConstants.businessVisibility) != true) {
      widget.addListingFormCubit.onFieldsValueChanged(
        key: AddListingFormConstants.businessVisibility,
        value: DropDownConstants.countrywide,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelText(
                title: AddListingFormConstants.streetAddress,
                textStyle: FontTypography.subTextStyle,
                isRequired: false,
              ),
              AppTextField(
                hintTxt: AddListingFormConstants.enterStreetAddress,
                initialValue: widget.state.formDataMap?[AddListingFormConstants.streetAddress],
                onChanged: (value) {
                  widget.addListingFormCubit.onFieldsValueChanged(
                    key: AddListingFormConstants.streetAddress,
                    value: value,
                  );
                  handleInitialValues();
                },
              ),
              LabelText(
                title: AddListingFormConstants.location,
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
              LabelText(
                title: AddListingFormConstants.businessEmail,
                textStyle: FontTypography.subTextStyle,
              ),
              AppTextField(
                hintTxt: AddListingFormConstants.enterBusinessEmail,
                textCapitalization: TextCapitalization.none,
                initialValue: widget.state.formDataMap?[AddListingFormConstants.businessEmail],
                onChanged: (value) {
                  widget.addListingFormCubit.onFieldsValueChanged(
                    key: AddListingFormConstants.businessEmail,
                    value: value,
                  );
                },
              ),
              LabelText(
                title: AddListingFormConstants.businessWebsite,
                isRequired: false,
                textStyle: FontTypography.subTextStyle,
              ),
              AppTextField(
                textCapitalization: TextCapitalization.none,
                hintTxt: AddListingFormConstants.enterBusinessWebsite,
                initialValue: widget.state.formDataMap?[AddListingFormConstants.businessWebsite],
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: value);
                  handleBusinessWebsite();
                },
              ),
              LabelText(
                title: AddListingFormConstants.businessPhone,
                textStyle: FontTypography.subTextStyle,
                isRequired: false,
              ),
              AppMobileTextField(
                hintText: AddListingFormConstants.mobileNumber,
                onChanged: (value) {
                  widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessPhone, value: value);
                },
                mobileTextEditController: mobileTxtController,
                phoneCodeController: phoneCodeController,
                countryCodeController: countryCodeController,
                textInputAction: TextInputAction.done,
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
            ],
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

  void handleInitialValues() {
    if (widget.state.apiResultId != null) {
      if (widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false) {
        /// Adding initial value of AddListingFormConstants.showStreetAddress if street address is available.
        widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.showStreetAddress, value: AddListingFormConstants.no);
      } else {
        /// Removing initial value of AddListingFormConstants.showStreetAddress if street address is removed by pressing back.
        /// Removing validation and there values
        RequiredFieldsConstants.removeValidations(
          requiredFieldsList: RequiredFieldsConstants.privacyPolicyRequiredFields,
          deleteKeys: [AddListingFormConstants.showStreetAddress],
        );
        widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.showStreetAddress, value: '');
      }
    }
  }

  void handleBusinessWebsite() {
    if (widget.state.formDataMap?.containsKey(AddListingFormConstants.businessWebsite) ?? false) {
      RequiredFieldsConstants.contactDetailsRequiredFields = RequiredFieldsConstants.contactDetailsRequiredFields
        ..addAll(
          {
            AddListingFormConstants.businessWebsite: FormValidationRegex.websiteRegex,
          },
        );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: '');
      RequiredFieldsConstants.contactDetailsRequiredFields = RequiredFieldsConstants.contactDetailsRequiredFields
        ..remove(
          AddListingFormConstants.businessWebsite,
        );
    }
  }
}
