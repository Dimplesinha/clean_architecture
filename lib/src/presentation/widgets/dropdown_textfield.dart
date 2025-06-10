import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 05/09/24
/// @Message : [MyDropdownButton]

class MyDropdownButton extends StatelessWidget {
  final String hint;
  final String? title;
  final GestureTapCallback? onTap;
  final bool? isDisplayDropdown;

  const MyDropdownButton({Key? key, required this.hint, this.title, this.onTap, this.isDisplayDropdown}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: title == null
                  ? Text(
                hint,
                style: FontTypography.textFieldHintStyle,
              )
                  : Text(
                title ?? '',
                maxLines: 2,
                style: FontTypography.textFieldGreyTextStyle,
              ),
            ),
            Visibility(
                visible: isDisplayDropdown == false ? false : true,
                child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.blackColor))
          ],
        ),
      ),
    );
  }
}
