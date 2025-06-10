import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

extension InputDecorations on InputDecoration {
  InputDecoration get decoration => InputDecoration(
        hintStyle: FontTypography.textFieldGreyTextStyle,
        constraints: const BoxConstraints(
            minHeight: AppConstants.constTxtFieldHeight, maxHeight: AppConstants.constTxtFieldHeight),
        suffixIconConstraints: const BoxConstraints(minHeight: 20, maxHeight: 20, minWidth: 40, maxWidth: 40),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        fillColor: AppColors.backgroundColor,
        filled: true,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.constBorderRadius),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
      );
}

OutlineInputBorder get searchBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(constSearchBorderRadius),
      borderSide: BorderSide(
        color: AppColors.borderColor,
      ),
    );
