import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class WorkersBasicDetailsFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const WorkersBasicDetailsFormView({
    super.key,
    required this.addListingFormCubit,
    required this.state,
  });

  @override
  State<WorkersBasicDetailsFormView> createState() => _WorkersBasicDetailsFormViewState();
}

class _WorkersBasicDetailsFormViewState extends State<WorkersBasicDetailsFormView> {
  @override
  void initState() {
    /// Setting initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.addListingFormCubit.onFieldsValueChanged(
        key: AddListingFormConstants.selectVisibility,
        value: DropDownConstants.countrywide,
      );
    });
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
            title: AddListingFormConstants.workerName,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.workerName,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.workerName],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.workerName, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.workerDescription,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.workerDescription,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.workerDescription],
            height: 130,
            maxLines: 6,
            topPadding: 12,
            onChanged: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.workerDescription, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.selectVisibility,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            hintText: AddListingFormConstants.selectVisibility,
            items: DropDownConstants.visibilityDropDownListWithLocal.values.toList(),
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.selectVisibility],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.selectVisibility],
            dropDownOnChange: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.selectVisibility, value: value ?? '');
              handleValidation();
            },
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.selectVisibility] == DropDownConstants.local,
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

  void handleValidation() {
    /// Handling case of selecting Listing Visibility
    if (widget.state.formDataMap?[AddListingFormConstants.selectVisibility] == DropDownConstants.local) {
      /// Adding Validations
      RequiredFieldsConstants.workerBasicDetailsRequiredFields.addAll({
        AddListingFormConstants.selectRadius: null,
      });
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {AddListingFormConstants.selectRadius: DropDownConstants.fiftyKm},
      );
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.workerBasicDetailsRequiredFields,
        deleteKeys: [AddListingFormConstants.selectRadius],
      );
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.selectRadius: '',
      });
    }
  }
}
