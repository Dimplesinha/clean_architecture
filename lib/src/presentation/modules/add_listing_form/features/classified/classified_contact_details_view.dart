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
import 'package:workapp/src/utils/app_utils.dart';

class ClassifiedContactDetailsView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const ClassifiedContactDetailsView({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<ClassifiedContactDetailsView> createState() => _ClassifiedContactDetailsViewState();
}

class _ClassifiedContactDetailsViewState extends State<ClassifiedContactDetailsView> {
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();

  @override
  void initState() {
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.businessPhone] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneCountryCode] ?? '';

    if (!(widget.state.formDataMap?.containsKey(AddListingFormConstants.businessVisibility) ?? false)) {
      widget.addListingFormCubit
          .onFieldsValueChanged(key: AddListingFormConstants.businessVisibility, value: DropDownConstants.countrywide);
    }
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
            hintTxt: AddListingFormConstants.typeName,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.contactName],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.contactName, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.businessEmail,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.enterBusinessEmail,
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.emailAddress,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.businessEmail],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessEmail, value: value);
            },
          ),
          LabelText(
            visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
            title: AddListingFormConstants.businessWebsite,
            isRequired: false,
            textStyle: FontTypography.subTextStyle,
          ),
          Visibility(
            visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
            child: AppTextField(
              keyboardType: TextInputType.url,
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
            title: AddListingFormConstants.businessPhone,
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
            title: AddListingFormConstants.businessVisibility,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            hintText: AddListingFormConstants.businessVisibility,
            items: DropDownConstants.visibilityDropDownList.values.toList(),
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.businessVisibility],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.businessVisibility],
            dropDownOnChange: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(
                key: AddListingFormConstants.businessVisibility,
                value: value ?? '',
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
      RequiredFieldsConstants.classifiedContactDetailsRequiredFields =
          RequiredFieldsConstants.classifiedContactDetailsRequiredFields
            ..addAll(
              {
                AddListingFormConstants.businessWebsite: FormValidationRegex.websiteRegex,
              },
            );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: '');
      RequiredFieldsConstants.classifiedContactDetailsRequiredFields =
          RequiredFieldsConstants.classifiedContactDetailsRequiredFields
            ..remove(
              AddListingFormConstants.businessWebsite,
            );
    }
  }
}
