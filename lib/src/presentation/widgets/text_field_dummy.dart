import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';

class TextFieldDummy extends StatelessWidget {
  final String value;
  final Widget? suffixIcon;
  final Function()? onTap;

  const TextFieldDummy({super.key, required this.value, this.suffixIcon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: AppConstants.constTxtFieldHeight,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: AppColors.borderColor),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(value), suffixIcon ?? const SizedBox.shrink()],
          ),
        ),
      ),
    );
  }
}
