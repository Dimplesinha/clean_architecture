import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 17-09-2024
/// @Message : [AboutUsView]

///This view displays all about us related items in item details screen at the end of page.
class AboutUsView extends StatelessWidget {
  final String description;
  const AboutUsView({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    String aboutUsDetail =description;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            aboutUsDetail,
            style: FontTypography.subDetailsTxtStyle,
          ),
          sizedBox30Height(),
        ],
      ),
    );
  }
}
