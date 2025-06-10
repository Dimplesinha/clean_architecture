import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_regex.dart';

class JobContactDetailsFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final String? accountType;

  const JobContactDetailsFormView(
      {super.key, required this.addListingFormCubit, required this.state, this.accountType});

  @override
  State<JobContactDetailsFormView> createState() => _JobContactDetailsFormViewState();
}

class _JobContactDetailsFormViewState extends State<JobContactDetailsFormView> {
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();

  @override
  void initState() {
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.businessPhone] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneCountryCode] ?? '';
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
            title: AddListingFormConstants.name,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.typeName,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.name],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.name, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.businessEmail,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.enterBusinessEmail,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.businessEmail],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessEmail, value: value);
            },
          ),
          Visibility(
            visible: widget.accountType == AppConstants.businessStr,
            child: LabelText(
              title: AddListingFormConstants.businessWebsite,
              isRequired: false,
              textStyle: FontTypography.subTextStyle,
            ),
          ),
          Visibility(
            visible: widget.accountType == AppConstants.businessStr,
            child: AppTextField(
              hintTxt: AddListingFormConstants.enterBusinessWebsite,
              textCapitalization: TextCapitalization.none,
              keyboardType: TextInputType.url,
              initialValue: widget.state.formDataMap?[AddListingFormConstants.businessWebsite],
              onChanged: (value) {
                widget.addListingFormCubit
                    .onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: value);
                handleBusinessWebsite();
              },
            ),
          ),
          LabelText(
            title: AddListingFormConstants.businessPhone,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          AppMobileTextField(
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessPhone, value: value);
            },
            mobileTextEditController: mobileTxtController,
            phoneCodeController: phoneCodeController,
            countryCodeController: countryCodeController,
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
      RequiredFieldsConstants.jobContactDetailsRequiredFields = RequiredFieldsConstants.jobContactDetailsRequiredFields
        ..addAll(
          {
            AddListingFormConstants.businessWebsite: FormValidationRegex.websiteRegex,
          },
        );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: '');
      RequiredFieldsConstants.jobContactDetailsRequiredFields = RequiredFieldsConstants.jobContactDetailsRequiredFields
        ..remove(
          AddListingFormConstants.businessWebsite,
        );
    }
  }
}
