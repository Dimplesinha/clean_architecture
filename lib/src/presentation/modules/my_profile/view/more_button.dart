import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';


/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 19/09/24
/// @Message : [MoreButton]

class MoreButton extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onBlock;
  final VoidCallback onDelete;

  const MoreButton({
    super.key,
    required this.onCall,
    required this.onBlock,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppColors.backgroundColor,
      padding: EdgeInsets.zero,
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.more_vert,
          color: AppColors.whiteColor,
        ),
      ),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          value: 'call',
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    ReusableWidgets.createSvg(path: AssetPath.callIcon, size: 18.0, color: AppColors.jetBlackColor),
                    sizedBox10Width(),
                    Text(
                      AppConstants.callStr,
                      style: FontTypography.popupMenuTxtStyle,
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.borderColor),
            ],
          ),
        ),
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          value: 'block',
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    ReusableWidgets.createSvg(path: AssetPath.blockIcon, size: 18.0, color: AppColors.jetBlackColor),
                    sizedBox10Width(),
                    Text(
                      AppConstants.blockStr,
                      style: FontTypography.popupMenuTxtStyle,
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.borderColor),
            ],
          ),
        ),
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          value: 'delete',
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ReusableWidgets.createSvg(path: AssetPath.deleteIcon, size: 18.0, color: AppColors.jetBlackColor),
                sizedBox10Width(),
                Text(
                  AppConstants.deleteStr,
                  style: FontTypography.popupMenuTxtStyle,
                ),
              ],
            ),
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'call':
            onCall();
            break;
          case 'block':
            onBlock();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
    );
  }
}
