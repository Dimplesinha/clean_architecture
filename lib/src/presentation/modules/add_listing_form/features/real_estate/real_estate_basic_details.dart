import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [RealEstateBasicDetails]

class RealEstateBasicDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const RealEstateBasicDetails({super.key, required this.addListingFormCubit, required this.state});


  @override
  State<RealEstateBasicDetails> createState() => RealEstateBasicDetailsState();

}

class RealEstateBasicDetailsState extends State<RealEstateBasicDetails> {

  @override
  void initState() {
    widget.addListingFormCubit.getAllPropertyType();
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _businessName(),
          LabelText(
            title: AddListingFormConstants.propertyTitle,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.propertyTitleHint,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.propertyTitle],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.propertyTitle, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.propertyDescription,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            height: 100,
            maxLines: 5,
            hintTxt: AddListingFormConstants.propertyDescriptionHint,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.propertyDescription],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.propertyDescription, value: value);
            },
          ),
          _propertyTypeDropdown(),
        ],
      ),
    );
  }

  Widget _businessName() {
    String? businessName = widget.state.formDataMap?[AddListingFormConstants.businessName] ?? '';
    CommonDropdownModel? selectedItem;
    try {
      var list = widget.state.businessListResult;
      list = list?.where((item) => item.businessName == businessName).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.businessProfileId ?? 0, name: item?.businessName ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return Visibility(
      visible: (AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            title: AddListingFormConstants.businessName,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          DropDownWidget2(
            hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.businessName}',
            items: widget.state.businessListResult
                ?.map(
                  (item) => CommonDropdownModel(id: item.businessProfileId ?? 0, name: item.businessName ?? ''),
            )
                .toList(),
            dropDownValue: selectedItem,
            dropDownOnChange: (CommonDropdownModel? value) {
              widget.addListingFormCubit.onFieldsValueChanged(
                keysValuesMap: {
                  AddListingFormConstants.businessName: value?.name ?? '',
                  AddListingFormConstants.businessProfileId: value?.id.toString(),
                },
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _propertyTypeDropdown() {
    String? categoryTypeName = widget.state.formDataMap?[AddListingFormConstants.propertyType] ?? '';
    CommonDropdownModel? selectedItem;
    try {
      var list = widget.state.propertyType?.result;
      list = list?.where((item) => item.propertyTypeName == categoryTypeName).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.propertyTypeId ?? 0, name: item?.propertyTypeName ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.propertyType,
          textStyle: FontTypography.subTextStyle,
        ),
        DropDownWidget2(
          hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.propertyType}',
          items: widget.state.propertyType?.result
              ?.map(
                (item) => CommonDropdownModel(id: item.propertyTypeId ?? 0, name: item.propertyTypeName ?? ''),
              )
              .toList(),
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.propertyType: value?.name ?? '',
                AddListingFormConstants.propertyTypeId: value?.id.toString(),
              },
            );
          },
        ),
      ],
    );
  }
}
