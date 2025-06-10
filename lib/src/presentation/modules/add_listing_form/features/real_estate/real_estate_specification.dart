import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/radio_button_widget.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [RealEstateSpecification]

class RealEstateSpecification extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const RealEstateSpecification({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<RealEstateSpecification> createState() => _RealEstateSpecificationState();
}

class _RealEstateSpecificationState extends State<RealEstateSpecification> {
  @override
  void initState() {
    if (widget.state.apiResultId != null) {
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {
          AddListingFormConstants.petsAllowed: widget.state.formDataMap?[AddListingFormConstants.petsAllowed],
          AddListingFormConstants.landSizeUnit: widget.state.formDataMap?[AddListingFormConstants.landSizeUnit],
          AddListingFormConstants.buildingSizeUnit: widget.state.formDataMap?[AddListingFormConstants.buildingSizeUnit],
        },
      );
    } else {
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {
          AddListingFormConstants.petsAllowed: DropDownConstants.no,
          AddListingFormConstants.landSizeUnit: AddListingFormConstants.squareMeters,
          AddListingFormConstants.buildingSizeUnit: AddListingFormConstants.squareMeters,
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.beds,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.countsList,
                      dropDownOnChange: (value) {
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.beds, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.bedHint,
                      displaySelectedItem:
                          widget.state.formDataMap?[AddListingFormConstants.beds] ?? AddListingFormConstants.bedHint,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.beds],
                    ),
                  ],
                ),
              ),
              sizedBox10Width(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.baths,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.countsList,
                      dropDownOnChange: (value) {
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.baths, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.bathHint,
                      displaySelectedItem:
                          widget.state.formDataMap?[AddListingFormConstants.baths] ?? AddListingFormConstants.bathHint,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.baths],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.garages,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.countsList,
                      dropDownOnChange: (value) {
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.garages, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.garageHint,
                      displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.garages] ??
                          AddListingFormConstants.garageHint,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.garages],
                    ),
                  ],
                ),
              ),
              sizedBox10Width(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.pools,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.countsList,
                      dropDownOnChange: (value) {
                        widget.addListingFormCubit.onFieldsValueChanged(
                          key: AddListingFormConstants.pools,
                          value: value ?? '',
                        );
                      },
                      hintText: AddListingFormConstants.poolHint,
                      displaySelectedItem:
                          widget.state.formDataMap?[AddListingFormConstants.pools] ?? AddListingFormConstants.poolHint,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.pools],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.landSize,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    AppTextField(
                      hintTxt: AddListingFormConstants.landSize,
                      initialValue: widget.state.formDataMap?[AddListingFormConstants.landSize],
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: (value) {
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.landSize, value: value);
                      },
                    ),
                  ],
                ),
              ),
              sizedBox10Width(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.landSizeUnit,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.unitOfMeasureDropDownList.values.toList(),
                      dropDownOnChange: (value) {
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.landSizeUnit, value: value ?? '');
                      },
                      hintText: AddListingFormConstants.landSizeUnit,
                      displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.landSizeUnit] ??
                          AddListingFormConstants.landSizeUnit,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.landSizeUnit],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.buildingSize,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    AppTextField(
                      hintTxt: AddListingFormConstants.buildingSize,
                      initialValue: widget.state.formDataMap?[AddListingFormConstants.buildingSize],
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: (value) {
                        widget.addListingFormCubit
                            .onFieldsValueChanged(key: AddListingFormConstants.buildingSize, value: value);
                      },
                    ),
                  ],
                ),
              ),
              sizedBox10Width(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      title: AddListingFormConstants.buildingSizeUnit,
                      isRequired: false,
                      textStyle: FontTypography.subTextStyle,
                    ),
                    DropDownWidget(
                      items: DropDownConstants.unitOfMeasureDropDownList.values.toList(),
                      dropDownOnChange: (value) {
                        widget.addListingFormCubit.onFieldsValueChanged(
                          key: AddListingFormConstants.buildingSizeUnit,
                          value: value ?? '',
                        );
                      },
                      hintText: AddListingFormConstants.buildingSizeUnit,
                      displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.buildingSizeUnit] ??
                          AddListingFormConstants.buildingSizeUnit,
                      dropDownValue: widget.state.formDataMap?[AddListingFormConstants.buildingSizeUnit],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              LabelText(
                title: AddListingFormConstants.petsAllowed,
                textStyle: FontTypography.subTextStyle,
                isRequired: false,
              ),
              Row(
                children: [
                  RadioButtonWidget(
                    state: widget.state,
                    formConstantKey: AddListingFormConstants.petsAllowed,
                    addListingFormCubit: widget.addListingFormCubit,
                    title: AddListingFormConstants.no,
                  ),
                  sizedBox29Width(),
                  RadioButtonWidget(
                    state: widget.state,
                    formConstantKey: AddListingFormConstants.petsAllowed,
                    addListingFormCubit: widget.addListingFormCubit,
                    title: AddListingFormConstants.yes,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
