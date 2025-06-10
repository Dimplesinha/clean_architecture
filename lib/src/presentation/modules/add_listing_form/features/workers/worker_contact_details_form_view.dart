import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/radio_button_widget.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class WorkerContactDetailsFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const WorkerContactDetailsFormView({
    super.key,
    required this.addListingFormCubit,
    required this.state,
  });

  @override
  State<WorkerContactDetailsFormView> createState() => _WorkerContactDetailsFormViewState();
}

class _WorkerContactDetailsFormViewState extends State<WorkerContactDetailsFormView> {
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();

  void handleShowStreetAddress() {
    if (widget.state.formDataMap?.containsKey(AddListingFormConstants.streetAddress) ?? false) {
      RequiredFieldsConstants.workerContactDetailsRequiredFields = RequiredFieldsConstants.workerContactDetailsRequiredFields
        ..addAll(
          {AddListingFormConstants.showStreetAddress: null},
        );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.showStreetAddress, value: '');
      RequiredFieldsConstants.workerContactDetailsRequiredFields = RequiredFieldsConstants.workerContactDetailsRequiredFields
        ..remove(
          AddListingFormConstants.showStreetAddress,
        );
    }
  }

  @override
  void initState() {
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.businessPhone] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneCountryCode] ?? '';

    if (widget.state.formDataMap?[AddListingFormConstants.showStreetAddress] == null) {
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {AddListingFormConstants.showStreetAddress: AddListingFormConstants.no});
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
            title: AddListingFormConstants.contactName,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.contactName,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.contactName],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.contactName, value: value);
              handleShowStreetAddress();
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
          // LabelText(
          //   title: AddListingFormConstants.businessWebsite,
          //   isRequired: false,
          //   textStyle: FontTypography.subTextStyle,
          // ),
          // AppTextField(
          //   hintTxt: AddListingFormConstants.enterBusinessWebsite,
          //   initialValue: widget.state.formDataMap?[AddListingFormConstants.businessWebsite],
          //   onChanged: (value) {
          //     widget.addListingFormCubit
          //         .onFieldsValueChanged(key: AddListingFormConstants.businessWebsite, value: value);
          //   },
          // ),
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
              https://pms.prakashinfotech.com/issues/53525              if (isApply) mobileTxtController.text = '';
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
}
