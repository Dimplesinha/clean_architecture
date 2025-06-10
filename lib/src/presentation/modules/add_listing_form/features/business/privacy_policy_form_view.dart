import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/radio_button_widget.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class PrivacyPolicyFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const PrivacyPolicyFormView({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<PrivacyPolicyFormView> createState() => _PrivacyPolicyFormViewState();
}

class _PrivacyPolicyFormViewState extends State<PrivacyPolicyFormView> {
  @override
  void initState() {
    handleValidation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LabelText(
            title: AddListingFormConstants.businessVisibility,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            hintText: AddListingFormConstants.selectBusinessVisibility,
            items: DropDownConstants.visibilityDropDownListWithLocal.values.toList(),
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.businessVisibility],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.businessVisibility],
            dropDownOnChange: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.businessVisibility, value: value ?? '');
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
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.businessVisibility] == DropDownConstants.local,
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


  void handleValidation() {
    /// Handling case of selecting Listing Visibility
    if (widget.state.formDataMap?[AddListingFormConstants.businessVisibility] == DropDownConstants.local) {
      /// Adding Validations
      RequiredFieldsConstants.privacyPolicyRequiredFields.addAll({
        AddListingFormConstants.selectRadius: null,
      });
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.selectRadius: DropDownConstants.fiftyKm},
      );
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.privacyPolicyRequiredFields,
        deleteKeys: [AddListingFormConstants.selectRadius],
      );
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.selectRadius: '',
      });
    }
  }
}
