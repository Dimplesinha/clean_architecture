import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 10-10-2024
/// @Message : [AddAutoBasicDetails]

class AddAutoBasicDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final int? itemId;

  const AddAutoBasicDetails({super.key, required this.addListingFormCubit, required this.state, required this.itemId});

  @override
  State<AddAutoBasicDetails> createState() => _AddAutoBasicDetailsState();
}

class _AddAutoBasicDetailsState extends State<AddAutoBasicDetails> {
  @override
  void initState() {
    if (widget.itemId == null) {
      widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
        AddListingFormConstants.vehicleCondition: AddListingFormConstants.newVehicle,
        AddListingFormConstants.saleOrRentOrLease: DropDownConstants.sale,
        AddListingFormConstants.paymentInterval: DropDownConstants.perDay,
      });
    }

    super.initState();
    widget.addListingFormCubit.getAutoType();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// DealerShip
          _businessName(),

          ///Auto Type
          _autoType(),

          ///Auto Tittle
          LabelText(
            title: AddListingFormConstants.autoTitle,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.autoTitle,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.autoTitle],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.autoTitle, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.autoRegistered,
            textStyle: FontTypography.subTextStyle,
          ),
          Row(
            children: [
              _buildRadio(AddListingFormConstants.yes, AddListingFormConstants.yes),
              sizedBox29Width(),
              _buildRadio(AddListingFormConstants.no, AddListingFormConstants.no),
            ],
          ),

          ///Auto Registration Number
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.autoRegistered] == AddListingFormConstants.yes,
            child: LabelText(
              title: AddListingFormConstants.autoRegistrationNumber,
              isRequired: false,
              textStyle: FontTypography.subTextStyle,
            ),
          ),
          Visibility(
            visible: widget.state.formDataMap?[AddListingFormConstants.autoRegistered] == AddListingFormConstants.yes,
            child: AppTextField(
              hintTxt: AddListingFormConstants.hintAutoRegistrationNumber,
              initialValue: widget.state.formDataMap?[AddListingFormConstants.autoRegistrationNumber],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                widget.addListingFormCubit
                    .onFieldsValueChanged(key: AddListingFormConstants.autoRegistrationNumber, value: value);
              },
            ),
          ),
          LabelText(
            title: AddListingFormConstants.autoDescription,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.autoDescription,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.autoDescription],
            height: 130,
            maxLines: 6,
            topPadding: 12,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.autoDescription, value: value);
            },
          ),

          ///Auto Year
          LabelText(
            title: AddListingFormConstants.autoYear,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget(
            items: DropDownConstants.getAutoYearList(),
            dropDownOnChange: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.autoYear, value: value ?? '');
            },
            hintText: AddListingFormConstants.autoYear,
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.autoYear] ?? '',
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.autoYear],
          ),
          sizedBox20Height(),
        ],
      ),
    );
  }

  ///radio button ui
  Widget _buildRadio(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      child: InkWell(
        onTap: () {
          widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.autoRegistered, value: value);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16.0,
              width: 16.0,
              child: Radio<String>(
                value: value,
                groupValue:
                    widget.state.formDataMap?[AddListingFormConstants.autoRegistered] ?? AddListingFormConstants.auto,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  widget.addListingFormCubit
                      .onFieldsValueChanged(key: AddListingFormConstants.autoRegistered, value: value ?? '');
                },
              ),
            ),
            sizedBox5Width(),
            Text(title, style: FontTypography.defaultTextStyle),
          ],
        ),
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
      visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
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

  Widget _autoType() {
    String? autoType = widget.state.formDataMap?[AddListingFormConstants.autoType] ?? '';

    CommonDropdownModel? selectedItem;
    try {
      var list = widget.state.autoTypeList;
      list = list?.where((item) => item.autoTypeName == autoType).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.autoTypeId ?? 0, name: item?.autoTypeName ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.autoType,
          textStyle: FontTypography.subTextStyle,
        ),
        DropDownWidget2(
          hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.autoType}',
          items: widget.state.autoTypeList
              ?.map(
                (item) => CommonDropdownModel(id: item.autoTypeId ?? 0, name: item.autoTypeName ?? ''),
              )
              .toList(),
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.autoType: value?.name ?? '',
                AddListingFormConstants.autoTypeId: value?.id.toString(),
              },
            );
          },
        ),
      ],
    );
  }
}
