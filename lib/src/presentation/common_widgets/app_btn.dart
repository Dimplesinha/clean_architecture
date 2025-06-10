import 'package:flutter/material.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03-09-2024
/// @Message : [AppButton]

class AppButton extends StatelessWidget {
  final Function() function;
  final String title;
  final double? width;
  final double? elevation;
  final Color? bgColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  const AppButton(
      {Key? key,
      required this.function,
      required this.title,
      this.width,
      this.bgColor,
      this.textStyle,
      this.borderColor,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      height: AppConstants.constBtnHeight,
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
            elevation: elevation ?? 4.0,
            side: BorderSide(color: borderColor ?? Colors.transparent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
            ),
            backgroundColor: bgColor ?? AppColors.primaryColor),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: textStyle ?? FontTypography.appBtnStyle,
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final double? width;
  final Color? bgColor;

  const CancelButton({Key? key, required this.onPressed, required this.title, this.width, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      height: AppConstants.constBtnHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
                side: BorderSide(width: 1, color: AppColors.cancelButtonColor)),
            backgroundColor: bgColor ?? AppColors.primaryColor),
        child: Text(
          title,
          style: FontTypography.appBtnStyle.copyWith(color: AppColors.cancelButtonColor),
        ),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  final Function() function;
  final String title;
  final double? width;
  final Color? bgColor;

  const AppBackButton({Key? key, required this.function, required this.title, this.width, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      height: AppConstants.constBtnHeight,
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
                side: BorderSide(width: 1, color: AppColors.jetBlackColor)),
            backgroundColor: bgColor ?? AppColors.primaryColor),
        child: Text(
          title,
          style: FontTypography.appBtnStyle.copyWith(color: AppColors.jetBlackColor),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final Function() function;
  final String title;
  final double? width;
  final Color? bgColor;
  final String iconPath;
  final double? iconSize;
  final Color? color;
  final BorderSide? borderSide;

  const AppIconButton({
    Key? key,
    required this.function,
    required this.title,
    this.width,
    this.bgColor,
    required this.iconPath,
    this.iconSize,
    this.color,
    this.borderSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      height: AppConstants.constBtnHeight,
      child: ElevatedButton.icon(
        onPressed: function,
        icon: ReusableWidgets.createSvg(path: iconPath, size: iconSize ?? 16, color: color),
        iconAlignment: IconAlignment.start,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
            side: borderSide ?? BorderSide(width: 1, color: AppColors.jetBlackColor),
          ),
          backgroundColor: bgColor ?? AppColors.primaryColor,
        ),
        label: Text(
          title,
          style: FontTypography.snackBarButtonStyle.copyWith(color: color ?? AppColors.jetBlackColor),
        ),
      ),
    );
  }
}
