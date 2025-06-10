import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_regex.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [RealEstateContactDetails]

class RealEstateContactDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const RealEstateContactDetails({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<RealEstateContactDetails> createState() => _RealEstateContactDetailsState();
}

class _RealEstateContactDetailsState extends State<RealEstateContactDetails> {
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();

  @override
  void initState() {
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.businessPhone] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text = widget.state.formDataMap?[AddListingFormConstants.countryCode] ?? '';
    if (widget.state.formDataMap?[AddListingFormConstants.listingVisibility] == null) {
      widget.addListingFormCubit
          .onFieldsValueChanged(key: AddListingFormConstants.listingVisibility,
          value: DropDownConstants.countrywide);
    }

    if (widget.state.formDataMap?[AddListingFormConstants.showStreetAddress] == null) {
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.showStreetAddress: AddListingFormConstants.no
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    mobileTxtController.dispose();
    phoneCodeController.dispose();
    countryCodeController.dispose();
    super.dispose();
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
                key: AddListingFormConstants.countryCode,
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
          LabelText(
            title: AddListingFormConstants.businessWebsite,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.enterBusinessWebsite,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.businessWebsite],
            keyboardType: TextInputType.url,
            textCapitalization: TextCapitalization.none,
            onChanged: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: value);
              handleBusinessWebsite();
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
            },
            hintText: AddListingFormConstants.listingVisibility,
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
          ),
        ],
      ),
    );
  }

  void handleValidation() {
    /// Handling case of Entering Street Address
    if (widget.state.formDataMap?[AddListingFormConstants.streetAddress] != null) {
      /// Adding Validations
      RequiredFieldsConstants.realEstateContactDetailsRequiredFields.addAll({
        AddListingFormConstants.showStreetAddress: null,
      });
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.showStreetAddress: AppConstants.noStr},
      );
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.realEstateContactDetailsRequiredFields,
        deleteKeys: [AddListingFormConstants.showStreetAddress],
      );
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.showStreetAddress: AppConstants.noStr},
      );
    }
  }

  void handleBusinessWebsite() {
    if (widget.state.formDataMap?.containsKey(AddListingFormConstants.businessWebsite) ?? false) {
      RequiredFieldsConstants.realEstateContactDetailsRequiredFields = RequiredFieldsConstants.realEstateContactDetailsRequiredFields
        ..addAll(
          {
            AddListingFormConstants.businessWebsite: FormValidationRegex.websiteRegex,
          },
        );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: '');
      RequiredFieldsConstants.realEstateContactDetailsRequiredFields = RequiredFieldsConstants.realEstateContactDetailsRequiredFields
        ..remove(
          AddListingFormConstants.businessWebsite,
        );
    }
  }

}
