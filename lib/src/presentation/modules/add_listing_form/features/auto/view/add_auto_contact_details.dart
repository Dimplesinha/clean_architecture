
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
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
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [AddAutoContactDetails]
///

class AddAutoContactDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const AddAutoContactDetails({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<AddAutoContactDetails> createState() => _AddAutoContactDetailsState();
}

class _AddAutoContactDetailsState extends State<AddAutoContactDetails> {
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();

  @override
  void initState() {
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.businessPhone] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneCountryCode] ?? '';

    widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {AddListingFormConstants.listingVisibility: DropDownConstants.countrywide});

    super.initState();
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
            hintText: AddListingFormConstants.mobileNumber,
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessPhone, value: value);
            },
            countryCodeController: countryCodeController,
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
            visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
            child: LabelText(
              title: AddListingFormConstants.websiteStr,
              textStyle: FontTypography.subTextStyle,
              isRequired: false,
            ),
          ),
          Visibility(
            visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
            child: AppTextField(
              hintTxt: AddListingFormConstants.enterYourWebsiteHint,
              initialValue: widget.state.formDataMap?[AddListingFormConstants.enterYourWebsite],
              onChanged: (value) {
                widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.enterYourWebsite, value: value);
                handleBusinessWebsite();
              },
            ),
          ),
          LabelText(
            title: AddListingFormConstants.listingVisibility,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            hintText: AddListingFormConstants.selectVisibility,
            items: DropDownConstants.visibilityDropDownList.values.toList(),
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.listingVisibility],
            dropDownOnChange: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.listingVisibility, value: value ?? '');
            },
          ),
          sizedBox20Height(),
        ],
      ),
    );
  }

  bool checkPhoneNo(String countryCode) {
    var country = countries.where((element) {
      return element.code == countryCode;
    }).toList();
    var minLength = country.first.minLength;
    var maxLength = country.first.maxLength;

    if (mobileTxtController.text.length < minLength || mobileTxtController.text.length > maxLength) {
      return false;
    } else {
      return true;
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
      RequiredFieldsConstants.autoContactDetailsRequiredFields = RequiredFieldsConstants.autoContactDetailsRequiredFields
        ..addAll(
          {
            AddListingFormConstants.enterYourWebsite: FormValidationRegex.websiteRegex,
          },
        );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.enterYourWebsite, value: '');
      RequiredFieldsConstants.autoContactDetailsRequiredFields = RequiredFieldsConstants.autoContactDetailsRequiredFields
        ..remove(
          AddListingFormConstants.enterYourWebsite,
        );
    }
  }
}
