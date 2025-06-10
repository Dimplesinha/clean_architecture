import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04/09/24
/// @Message : [LabelText]
/// A widget that displays a label with optional required indicator.
///
/// The `LabelText` widget is typically used to label form fields.
/// It shows the label text along with an asterisk (*) if the field is required.
class LabelText extends StatelessWidget {
  /// The text to display as the label.
  final String title;

  /// The maximum number of lines the label text can occupy.
  /// If null, the text can take up as many lines as needed.
  final int? maxLines;

  /// Whether or not the label is for a required field.
  /// If true, an asterisk (*) is shown next to the label.
  final bool isRequired;
  final bool visible;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;

  const LabelText({
    Key? key,
    required this.title,
    this.isRequired = true,
    this.visible = true,
    this.maxLines,
    this.textStyle,
    this.padding = const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: textStyle ?? FontTypography.textFieldGreyTextStyle,
                maxLines: maxLines,
              ),
            ),
            Text(
              isRequired ? '*' : '',
              style: textStyle ?? FontTypography.textFieldGreyTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

/// The `Value Text` widget is typically used to create a fake read only value field of a Text Field.
/// It shows the value text below the Label Text.
class ValueText extends StatelessWidget {
  /// The text to display as the label.
  final String value;

  /// The maximum number of lines the label text can occupy.
  /// If null, the text can take up as many lines as needed.
  final int? maxLines;

  const ValueText({
    Key? key,
    required this.value,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: FontTypography.textFieldsValueStyle,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }
}
