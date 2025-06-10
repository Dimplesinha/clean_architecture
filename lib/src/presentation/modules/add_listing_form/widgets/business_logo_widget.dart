import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';

class BusinessLogoWidget extends StatelessWidget {
  final String? localImagePath;
  final String? networkImagePath;
  final Function()? onDeleteItemClick;
  final bool isUploading; // Add a flag to indicate if uploading is in progress

  const BusinessLogoWidget({
    super.key,
    this.localImagePath,
    this.networkImagePath,
    this.onDeleteItemClick,
    this.isUploading = false, // Set default to false
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: isUploading
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(AssetPath.dummyPlaceholderImage, fit: BoxFit.cover),
                )
              : Visibility(
                  visible: networkImagePath?.isNotEmpty ?? false,
                  replacement: Visibility(
                    visible: localImagePath?.isNotEmpty ?? false,
                    replacement: Image.asset(AssetPath.dummyPlaceholderImage, fit: BoxFit.cover),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(File(localImagePath ?? ''), fit: BoxFit.fill),
                    ),
                  ),
                  child: networkImagePath?.isEmpty ?? true
                      ? Image.asset(AssetPath.dummyPlaceholderImage, fit: BoxFit.cover)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: LoadNetworkImage(
                            url: networkImagePath ?? '',
                          ),
                        ),
                ),
        ),
        Positioned(
          top: -6,
          right: 4,
          child: InkWell(
            onTap: onDeleteItemClick,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: AppUtils.elevatedCircleAvatar(
                size: 26,
                path: AssetPath.deleteIcon,
                onPressed: onDeleteItemClick,
                iconSize: 16,
                iconColor: AppColors.blackColor,
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
