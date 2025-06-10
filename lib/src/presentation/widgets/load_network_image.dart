/// Created by
/// @AUTHOR : Jinal Soni
/// @DATE : 16-05-2024
/// @Message :

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';

class LoadNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final Widget? loaderWidget;
  final IconData iconData;

  const LoadNetworkImage({
    Key? key,
    required this.url,
    this.fit,
    this.height,
    this.width,
    this.errorWidget,
    this.loaderWidget,
    this.iconData = Icons.person_2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Handle empty or invalid URLs
    if (url.isEmpty) {
      return errorWidget ??
          SizedBox(
            width: width ?? double.maxFinite,
            height: height,
            child: Image.asset(
              AssetPath.dummyPlaceholderImage,
              fit: BoxFit.cover,
            ),
          );
    }

    /// Check if URL starts with "http"
    final isNetworkImage = url.startsWith('http');

    if (!isNetworkImage) {
      // Render local asset image
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
      );
    }

    // Render network image
    return CachedNetworkImage(
      width: width ?? double.maxFinite,
      height: height,
      imageUrl: url,
      fit: fit ?? BoxFit.cover,
      errorWidget: (BuildContext context, String url, dynamic error) {
        return errorWidget ??
            Image.asset(
              AssetPath.dummyPlaceholderImage,
              fit: BoxFit.cover,
            );
      },
      progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress progress) {
        return loaderWidget ??
            Image.asset(
              AssetPath.dummyPlaceholderImage,
              fit: BoxFit.cover,
            );
      },
    );
  }
}

class LoadNetworkImageProvider {
  static NetworkImage getNetworkImageProvider({required String url}) {
    return NetworkImage(url);
  }
}

class LoadProfileImage extends StatelessWidget {
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final Widget? loaderWidget;
  final IconData iconData;

  const LoadProfileImage({
    Key? key,
    required this.url,
    this.fit,
    this.height,
    this.width,
    this.errorWidget,
    this.loaderWidget,
    this.iconData = Icons.person_2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Handle empty or invalid URLs
    if (url?.isEmpty ?? true) {
      return errorWidget ??
          Container(
            color: AppColors.borderColor,
            child: const Icon(Icons.person_2, size: 30),
          );
    }

    /// Check if URL starts with "http"
    final isNetworkImage = url!.startsWith('http');

    if (!isNetworkImage) {
      // Render local asset image
      return Image.asset(
        url!,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
      );
    }

    // Render network image
    return CachedNetworkImage(
      width: width ?? double.maxFinite,
      height: height,
      imageUrl: url!,
      fit: fit ?? BoxFit.cover,
      errorWidget: (BuildContext context, String url, dynamic error) {
        return Container(
          color: AppColors.borderColor,
          child: errorWidget ?? const Icon(Icons.person_2, size: 30),
        );
      },
      progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress progress) {
        return Container(
          color: AppColors.borderColor,
          child: loaderWidget ?? const Icon(Icons.person_2, size: 30),
        );
      },
    );
  }
}
