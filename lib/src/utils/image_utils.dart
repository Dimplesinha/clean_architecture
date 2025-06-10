/// Created by
/// @AUTHOR : Jinal Soni
/// @DATE : 16-05-2024
/// @Message :

import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:workapp/src/utils/app_utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:workapp/src/core/core_exports.dart';

class ImageUtils {
  static final ImageUtils _singleton = ImageUtils._internal();

  ImageUtils._internal();

  static ImageUtils get instance => _singleton;

  final imageValidRegex = RegExp(r'[^\s]+(.*?).(jpg|jpeg|png|JPG|JPEG|PNG)$');

  Future<XFile?> compressImage(String srcPath) async {
    try {
      final File file = File(srcPath);
      final name = file.getFileName();
      final String newFilePath = srcPath.replaceAll(name, '').trim();

      final type = getFileExtension(name) == 'jpeg' || getFileExtension(name) == 'jpg'
          ? CompressFormat.jpeg
          : getFileExtension(name) == 'png'
          ? CompressFormat.png
          : getFileExtension(name) == 'webp'
          ? CompressFormat.webp
          : getFileExtension(name) == 'heic'
          ? CompressFormat.heic
          : CompressFormat.png;

      final String target = type.name == 'jpeg' || type.name == 'jpg'
          ? '$newFilePath${DateTime.now().millisecondsSinceEpoch}.jpg'
          : type.name == 'png'
          ? '$newFilePath${DateTime.now().millisecondsSinceEpoch}.png'
          : type.name == 'webp'
          ? '$newFilePath${DateTime.now().millisecondsSinceEpoch}.webp'
          : type.name == 'heic'
          ? '$newFilePath${DateTime.now().millisecondsSinceEpoch}.heic'
          : '$newFilePath${DateTime.now().millisecondsSinceEpoch}.png';

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        srcPath,
        target,
        format: type,
        quality: 75,
      );
      if (result == null) return null;

      // Check the size of the compressed image
      final File compressedFile = File(result.path);
      final int fileSizeInBytes = compressedFile.lengthSync();
      final double fileSizeInMB = fileSizeInBytes / (1024 * 1024); // Convert bytes to MB

      if (fileSizeInMB <= 10) {
        return result;
      } else {
        // If the size is greater than 10 MB, return null or handle the oversized image as needed
        // For example, you can delete the oversized image file here.
        await compressedFile.delete();
        return AppUtils.showErrorSnackBar(AppConstants.imageSizeValidation);
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return AppUtils.showErrorSnackBar(AppConstants.somethingWentWrong);
    }
  }

  String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }
}

extension FileNameExtension on File {
  String getFileName() {
    String fileName = path.split('/').last;
    return fileName;
  }
}
