import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';

import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

///Location Widget
Widget locationWidget(String? address) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableWidgets.createSvg(path: AssetPath.locationPinIcon, size: 17),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              (address?.trim()).isNullOrEmpty() ? AppConstants.noAddressStr : (address ?? ''),
              style: FontTypography.addressStyle.copyWith(overflow: TextOverflow.ellipsis),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: ReusableWidgets.createSvg(path: AssetPath.arrowDownIcon, size: 6),
        ),
      ],
    ),
  );
}
