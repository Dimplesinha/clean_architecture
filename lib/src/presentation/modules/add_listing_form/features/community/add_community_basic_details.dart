import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_utils.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [AddCommunityBasicDetails]

class AddCommunityBasicDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const AddCommunityBasicDetails({
    super.key,
    required this.addListingFormCubit,
    required this.state,
  });

  @override
  State<AddCommunityBasicDetails> createState() => _AddCommunityBasicDetailsState();
}

class _AddCommunityBasicDetailsState extends State<AddCommunityBasicDetails> {
  @override
  void initState() {
    widget.addListingFormCubit.communityTypeDisplay();
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
            title: AddListingFormConstants.communityType,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            items: DropDownConstants.communityTypeDropDownList.values.toList(),
            dropDownOnChange: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.communityType, value: value ?? '');
              handleValidation();
            },
            hintText: AddListingFormConstants.communityTypeHint,
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.communityType] ?? '',
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.communityType],
          ),
          LabelText(
            title: AddListingFormConstants.listingTitle,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.listingTitle,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.listingTitle],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.listingTitle, value: value);
            },
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.communityType] == DropDownConstants.individual,
            child: Column(
              children: [
                _communityListingType(),
                Visibility(
                  visible: widget.state.formDataMap?[AddListingFormConstants.communityListingType] ==
                      DropDownConstants.other,
                  child: Column(
                    children: [
                      LabelText(
                        title: AddListingFormConstants.describeOtherCommunityListingType,
                        textStyle: FontTypography.subTextStyle,
                      ),
                      AppTextField(
                        hintTxt: AddListingFormConstants.describeOtherCommunityListingType,
                        initialValue:
                        widget.state.formDataMap?[AddListingFormConstants.describeOtherCommunityListingType],
                        onChanged: (value) {
                          widget.addListingFormCubit.onFieldsValueChanged(
                              key: AddListingFormConstants.describeOtherCommunityListingType, value: value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          LabelText(
            title: AddListingFormConstants.communityDescription,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            height: 100,
            maxLines: 5,
            hintTxt: AddListingFormConstants.communityDescription,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.communityDescription],
            onChanged: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.communityDescription, value: value);
            },
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.communityType] == DropDownConstants.individual,
            child: Column(
              children: [
                LabelText(
                  title: AddListingFormConstants.skill,
                  textStyle: FontTypography.subTextStyle,
                ),
                DropDownWidget(
                  items: DropDownConstants.skillDropDownList.values.toList(),
                  dropDownOnChange: (value) {
                    widget.addListingFormCubit
                        .onFieldsValueChanged(key: AddListingFormConstants.skill, value: value ?? '');
                    handleValidation();
                  },
                  hintText: AddListingFormConstants.chooseSkill,
                  displaySelectedItem:
                  widget.state.formDataMap?[AddListingFormConstants.skill] ?? AddListingFormConstants.chooseSkill,
                  dropDownValue: widget.state.formDataMap?[AddListingFormConstants.skill],
                ),
              ],
            ),
          ),
          Visibility(
            visible: (widget.state.formDataMap?[AddListingFormConstants.skill] == DropDownConstants.other),
            child: Column(
              children: [
                LabelText(
                  title: AddListingFormConstants.describeOtherSkill,
                  textStyle: FontTypography.subTextStyle,
                ),
                AppTextField(
                  hintTxt: AddListingFormConstants.describeOtherSkill,
                  initialValue: widget.state.formDataMap?[AddListingFormConstants.describeOtherSkill],
                  onChanged: (value) {
                    widget.addListingFormCubit
                        .onFieldsValueChanged(key: AddListingFormConstants.describeOtherSkill, value: value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _communityListingType() {
    String? communityType = widget.state.formDataMap?[AddListingFormConstants.communityListingType] ?? '';
    var list = widget.state.communityListingTypeResult;
    CommonDropdownModel? selectedItem = AddListingUtils.getCommunityListingTypeDropdownItem(communityType, list);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.communityListingType,
          textStyle: FontTypography.subTextStyle,
        ),
        DropDownWidget2(
          hintText: AddListingFormConstants.communityListingType,
          items: widget.state.communityListingTypeResult?.map((item) => CommonDropdownModel(id: item.communityListingTypeId ?? 0, name: item.name ?? '')).toList(),
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.communityListingType: value?.name ?? '',
                AddListingFormConstants.communityListingTypeId: value?.id.toString(),
              },
            );
            handleValidation();
          },
        ),
      ],
    );
  }

  void handleValidation() {
    /// Handling case of selecting communityType
    if (widget.state.formDataMap?[AddListingFormConstants.communityType] == DropDownConstants.individual) {
      /// Adding Validations
      RequiredFieldsConstants.communityBasicDetailsRequiredFields.addAll({
        AddListingFormConstants.communityListingType: null,
        AddListingFormConstants.skill: null,
      });
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.communityBasicDetailsRequiredFields,
        deleteKeys: [
          AddListingFormConstants.communityListingType,
          AddListingFormConstants.skill,
        ],
      );
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.communityListingType: '',
        AddListingFormConstants.skill: '',
      });
    }

    /// Handling case of selecting community Listing type
    if (widget.state.formDataMap?[AddListingFormConstants.communityListingType] == DropDownConstants.other) {
      /// Adding Validations
      RequiredFieldsConstants.communityBasicDetailsRequiredFields.addAll({
        AddListingFormConstants.describeOtherCommunityListingType: null,
      });
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.communityBasicDetailsRequiredFields,
        deleteKeys: [AddListingFormConstants.describeOtherCommunityListingType],
      );
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.describeOtherCommunityListingType: '',
      });
    }

    /// Handling case of selecting community Listing type
    if (widget.state.formDataMap?[AddListingFormConstants.skill] == DropDownConstants.other) {
      /// Adding Validations
      RequiredFieldsConstants.communityBasicDetailsRequiredFields.addAll({
        AddListingFormConstants.describeOtherSkill: null,
      });
    } else {
      /// Removing validation and there values
      RequiredFieldsConstants.removeValidations(
        requiredFieldsList: RequiredFieldsConstants.communityBasicDetailsRequiredFields,
        deleteKeys: [AddListingFormConstants.describeOtherSkill],
      );
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.describeOtherSkill: '',
      });
    }
  }
}
