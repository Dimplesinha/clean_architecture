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

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [AddCommunityContactDetails]
///

class AddCommunityContactDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const AddCommunityContactDetails({
    super.key,
    required this.addListingFormCubit,
    required this.state,
  });

  @override
  State<AddCommunityContactDetails> createState() => _AddCommunityContactDetailsState();
}

class _AddCommunityContactDetailsState extends State<AddCommunityContactDetails> {
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();

  @override
  void initState() {
    handleListingVisibilityDropDownItems();
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.businessPhone] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneCountryCode] ?? '';
    if (widget.state.formDataMap?[AddListingFormConstants.listingVisibility] == null) {
      widget.addListingFormCubit
          .onFieldsValueChanged(key: AddListingFormConstants.listingVisibility, value: DropDownConstants.countrywide);
    }
    if (widget.state.formDataMap?[AddListingFormConstants.showStreetAddress] == null) {
      widget.addListingFormCubit
          .onFieldsValueChanged(keysValuesMap: {AddListingFormConstants.showStreetAddress: AddListingFormConstants.no});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
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
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          AppMobileTextField(
            mobileTextEditController: mobileTxtController,
            phoneCodeController: phoneCodeController,
            hintText: AddListingFormConstants.mobileNumber,
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessPhone, value: value);
            },
            onPhoneCountryChanged: (String countryCode, String countryPhoneCode,bool isApply) {
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
            countryCodeController: countryCodeController,
          ),
          LabelText(
            title: AddListingFormConstants.contactEmail,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.emailHint,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.contactEmail],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.contactEmail, value: value);
            },
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.communityType] == DropDownConstants.organisation,
            child: Column(
              children: [
                LabelText(
                  title: AddListingFormConstants.enterYourWebsite,
                  textStyle: FontTypography.subTextStyle,
                  isRequired: false,
                ),
                AppTextField(
                  hintTxt: AddListingFormConstants.enterYourWebsiteHint,
                  initialValue: widget.state.formDataMap?[AddListingFormConstants.enterYourWebsite],
                  onChanged: (value) {
                    widget.addListingFormCubit
                        .onFieldsValueChanged(key: AddListingFormConstants.enterYourWebsite, value: value);
                    handleBusinessWebsite();
                  },
                ),
              ],
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
              handleValidation();
            },
          ),
          Visibility(
            visible: widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false,
            child: Column(
              children: [
                LabelText(
                  title: AddListingFormConstants.showStreetAddress,
                  textStyle: FontTypography.subTextStyle,
                ),
                Row(
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
              ],
            ),
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
            title: AddListingFormConstants.listingVisibility,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            items: DropDownConstants.visibilityDropDownList.values.toList(),
            dropDownOnChange: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.listingVisibility, value: value ?? '');
              handleValidation();
            },
            hintText: AddListingFormConstants.listingVisibility,
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.listingVisibility] == DropDownConstants.local,
            replacement: const SizedBox.shrink(),
            child: Column(
              children: [
                LabelText(
                  title: AddListingFormConstants.selectRadius,
                  textStyle: FontTypography.subTextStyle,
                ),
                DropDownWidget(
                  hintText: AddListingFormConstants.selectRadius,
                  items: DropDownConstants.radiusDropDownList,
                  displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.selectRadius],
                  dropDownValue: widget.state.formDataMap?[AddListingFormConstants.selectRadius],
                  dropDownOnChange: (value) {
                    widget.addListingFormCubit
                        .onFieldsValueChanged(key: AddListingFormConstants.selectRadius, value: value ?? '');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void handleListingVisibilityDropDownItems() {
    /// Handling case of selecting communityType
    if (widget.state.formDataMap?[AddListingFormConstants.communityType] == DropDownConstants.individual) {
      DropDownConstants.visibilityDropDownList.addAll({3: DropDownConstants.local});
    } else {
      DropDownConstants.visibilityDropDownList.remove(3);
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.selectRadius: '',
      });
    }
  }

  void handleValidation() {
    /// Handling case of Entering Street Address
    if (widget.state.formDataMap?[AddListingFormConstants.streetAddress] != null) {
      /// Adding Validations
      RequiredFieldsConstants.communityContactDetailsRequiredFields.addAll({
        AddListingFormConstants.showStreetAddress: null,
      });
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.communityContactDetailsRequiredFields,
        deleteKeys: [AddListingFormConstants.showStreetAddress],
      );
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.showStreetAddress: ''},
      );
    }

    /// Handling case of selecting Listing Visibility
    if (widget.state.formDataMap?[AddListingFormConstants.listingVisibility] == DropDownConstants.local) {
      /// Adding Validations
      RequiredFieldsConstants.communityContactDetailsRequiredFields.addAll({
        AddListingFormConstants.selectRadius: null,
      });
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.selectRadius: DropDownConstants.fiftyKm},
      );
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.communityContactDetailsRequiredFields,
        deleteKeys: [AddListingFormConstants.selectRadius],
      );
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.selectRadius: '',
      });
    }
  }

  @override
  void dispose() {
    mobileTxtController.dispose();
    phoneCodeController.dispose();
    countryCodeController.dispose();
    super.dispose();
  }

  void handleBusinessWebsite() {
    if (widget.state.formDataMap?.containsKey(AddListingFormConstants.enterYourWebsite) ?? false) {
      RequiredFieldsConstants.communityContactDetailsRequiredFields =
          RequiredFieldsConstants.communityContactDetailsRequiredFields
            ..addAll(
              {
                AddListingFormConstants.enterYourWebsite: FormValidationRegex.websiteRegex,
              },
            );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.enterYourWebsite, value: '');
      RequiredFieldsConstants.communityContactDetailsRequiredFields =
          RequiredFieldsConstants.communityContactDetailsRequiredFields
            ..remove(
              AddListingFormConstants.enterYourWebsite,
            );
    }
  }
}
