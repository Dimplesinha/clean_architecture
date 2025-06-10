import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/style/style.dart';

/// Created by
/// @AUTHOR :  Prakash Software Solutions Pvt Ltd
/// @DATE : 08-10-2024
/// @Message : [DropDownWidget]

class DropDownWidget extends StatefulWidget {
  final String? hintText;
  final String? displaySelectedItem;
  final String? dropDownValue;
  final double? dropDownWidth;
  final List<DropdownMenuItem<String>>? dropDownMenuItems;
  final List<String>? items;
  final Function(String?)? dropDownOnChange;

  const DropDownWidget({
    super.key,
    this.hintText,
    this.dropDownMenuItems,
    this.items,
    this.displaySelectedItem,
    this.dropDownWidth,
    required this.dropDownValue,
    this.dropDownOnChange,
  });

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  List<DropdownMenuItem<String>> dropDownMenuItemsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items?.isNotEmpty ?? false) {
      dropDownMenuItemsList = widget.items!
          .map(
            (String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: FontTypography.textFieldBlackStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList();
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        customButton: Container(
          height: AppConstants.constTxtFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(constBorderRadius),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Visibility(
                  visible: widget.displaySelectedItem?.isNotEmpty ?? false,
                  replacement: Text(
                     widget.hintText ?? '',
                    style: FontTypography.textFieldHintStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  child: Text(
                    widget.displaySelectedItem ?? '',
                    maxLines: 1,
                    style: FontTypography.listingStatTxtStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SvgPicture.asset(AssetPath.iconDropDown),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
          ),
        ),
        items: dropDownMenuItemsList.isNotEmpty ? dropDownMenuItemsList : widget.dropDownMenuItems,
        value: widget.dropDownValue,
        onChanged: widget.dropDownOnChange,
      ),
    );
  }
}

class DropDownWidget2 extends StatefulWidget {
  final String? hintText;
  final CommonDropdownModel? dropDownValue;
  final double? dropDownWidth;
  // final List<DropdownMenuItem<CommonDropdownModel>>? dropDownMenuItems;
  final List<CommonDropdownModel>? items;
  final Function(CommonDropdownModel?)? dropDownOnChange;
  final int? bindValue;

  const DropDownWidget2({
    Key? uniqueKey,
    super.key,
    this.hintText,
    // this.dropDownMenuItems,
    this.items,
    this.dropDownWidth,
    required this.dropDownValue,
    this.dropDownOnChange,
    this.bindValue,
  });

  @override
  State<DropDownWidget2> createState() => _DropDownWidgetState2();
}

class _DropDownWidgetState2 extends State<DropDownWidget2> {
  List<DropdownMenuItem<CommonDropdownModel>> dropDownMenuItemsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items?.isNotEmpty ?? false) {
      dropDownMenuItemsList = (widget.items ?? []).map(
        (CommonDropdownModel item) {
          return DropdownMenuItem<CommonDropdownModel>(
            value: item,
            child: Text(
              item.name ?? '',
              style: FontTypography.textFieldBlackStyle,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ).toList();
    }else{
      dropDownMenuItemsList=[];
    }
    return DropdownButtonHideUnderline(
      key: UniqueKey(),
      child: DropdownButton2<CommonDropdownModel>(
        isExpanded: true,
        customButton: Container(
          height: AppConstants.constTxtFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(constBorderRadius),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Visibility(
                  visible: widget.dropDownValue != null,
                  replacement: Text(
                    widget.hintText ?? '',
                    maxLines: 1,
                    style: FontTypography.textFieldHintStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  child: Text(
                    widget.dropDownValue?.name ?? '',
                    maxLines: 1,
                    style: FontTypography.listingStatTxtStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SvgPicture.asset(AssetPath.iconDropDown),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(color: AppColors.backgroundColor),
        ),
        items: dropDownMenuItemsList,
        onChanged: widget.dropDownOnChange,
      ),
    );
  }
}

///  CommonDropdownModel with id and name param

class CommonDropdownModel {
  int? id;
  String? name;
  String? code;
  String? countryName;
  String? countryCode;
  String? currencySymbol;

  CommonDropdownModel({
    required this.id,
    required this.name,
    this.code,
    this.countryName,
    this.currencySymbol,
  });

  @override
  String toString() {
    return 'CommonDropdownModel{id: $id, name: $name, code: $code, countryName: $countryName, countryCode: $countryCode, currencySymbol: $currencySymbol}';
  }



}
