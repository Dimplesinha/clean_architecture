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
  final String hintText;
  final String displaySelectedItem;
  final String? dropDownValue;
  final double? dropDownWidth;
  final List<DropdownMenuItem<String>> items;
  final Function(String?)? dropDownOnChange;

  const DropDownWidget(
      {super.key,
      required this.hintText,
      required this.items,
      required this.displaySelectedItem,
      this.dropDownWidth,
      required this.dropDownValue,
      this.dropDownOnChange});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          widget.hintText,
          style: FontTypography.textFieldHintStyle.copyWith(overflow: TextOverflow.ellipsis),
          overflow: TextOverflow.ellipsis,
        ),
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
              SizedBox(
                width: widget.dropDownWidth ?? MediaQuery.of(context).size.width / 1.4,
                child: Text(
                  widget.displaySelectedItem,
                  style: FontTypography.textFieldHintStyle.copyWith(overflow: TextOverflow.ellipsis),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(AssetPath.iconDropDown),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
          ),
        ),
        items: widget.items,
        value: widget.dropDownValue,
        onChanged: widget.dropDownOnChange,
      ),
    );
  }
}
