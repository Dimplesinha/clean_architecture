import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03-09-2024
/// @Message : [AppTextField]

///AppTextField made for using text-field through out the app
///below are some mention parameter that can be customized as per usage
///pre defined decoration is done which will stay same throughout app
/// and a basic validation is done for email ID
class AppTextField extends StatelessWidget {
  final double? height;
  final double? width;
  final String? hintTxt;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? isMandateField;
  final bool? isReadOnly;
  final bool? isEnable;
  final bool? isError;
  final int? maxInputLine;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final TextStyle? hintStyle;
  final TextAlignVertical? textAlignVertical;
  final bool? isExpanded;
  final bool? obscureText;
  final int? maxLines;
  final int? maxLength;
  final double? topPadding;
  final TextCapitalization? textCapitalization;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  final FocusNode? focusNode;
  final int? minLines;
  final Color? fillColor;
  final bool? autoValidate;
  final Function()? onTap;
  final String? errorTxt;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? inputTextStyle;

  const AppTextField({
    Key? key,
    this.height,
    this.width,
    this.hintTxt,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.maxInputLine,
    this.suffix,
    this.isReadOnly,
    this.isEnable,
    this.onTap,
    this.isMandateField,
    this.isError,
    this.errorTxt,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    this.textAlignVertical,
    this.textCapitalization,
    this.isExpanded,
    this.obscureText,
    this.maxLines,
    this.maxLength,
    this.onEditingComplete,
    this.onChanged,
    this.topPadding,
    this.focusNode,
    this.prefixIconConstraints,
    this.inputFormatters,
    this.onSubmit,
    this.suffixIconConstraints,
    this.minLines,
    this.fillColor,
    this.autoValidate,
    this.inputTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        minLines: minLines,
        onChanged: onChanged,
        focusNode: focusNode,
        maxLength: maxLength,
        expands: isExpanded ?? false,
        onFieldSubmitted: onSubmit,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        controller: controller,
        /// If hint contains email then keyboard is of email type
        /// If hint contains website then keyboard is of url type
        /// Else it is null
        keyboardType: keyboardType ??
            (hintTxt.toString().toLowerCase().contains(AppConstants.emailStr.toLowerCase())
                ? TextInputType.emailAddress
                : hintTxt.toString().toLowerCase().contains(AppConstants.websiteStr.toLowerCase())
                    ? TextInputType.url
                    : keyboardType),
        textInputAction: textInputAction ?? TextInputAction.next,
        obscureText: obscureText ?? false,
        style: inputTextStyle ?? FontTypography.textFieldBlackStyle,
        textAlignVertical: textAlignVertical,
        onTap: onTap,
        readOnly: isReadOnly ?? false,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        cursorColor: AppColors.primaryColor,
        initialValue: initialValue,
        autocorrect: autoValidate ?? false,
        decoration: const InputDecoration().decoration.copyWith(
              suffix: suffix,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              suffixIconConstraints: suffixIconConstraints,
              prefixIconConstraints: prefixIconConstraints,
              hintText: hintTxt,
              counterText: '',
              hintStyle: hintStyle??FontTypography.textFieldHintStyle,
              fillColor: fillColor,
              contentPadding: EdgeInsets.only(left: 15, right: 15, top: topPadding ?? 0.0),
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.borderColor)),
              enabled: isEnable,
              // errorText: isError == false ? errorTxt : null,
              errorStyle: TextStyle(color: AppColors.errorColor),
            ),
        validator: isMandateField == false
            ? (value) {
                if (value == null || value.isEmpty) {
                  if (isReadOnly == true) {
                    return '${AppConstants.pleaseSelectStr} + $hintTxt';
                  } else if (keyboardType == TextInputType.emailAddress && value!.isNotEmpty) {
                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return AppConstants.emailValidationStr;
                    }
                  } else {
                    return '${AppConstants.pleaseEnterStr} + $hintTxt';
                  }
                }
                return null;
              }
            : null,
      ),
    );
  }
}

class ReadOnlyTextField extends StatelessWidget {
  final String title;
  final String value;
  final int? maxLine;
  final bool isRequired;


  const ReadOnlyTextField({super.key, required this.title, required this.value, this.maxLine = 1, this.isRequired=true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelText(title: title,isRequired: isRequired,),
        ValueText(value: value, maxLines: maxLine),
        sizedBox20Height(),
        ReusableWidgets.createDivider(),
      ],
    );
  }
}
