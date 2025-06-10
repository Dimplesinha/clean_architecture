import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/image_utils.dart';

/// Created by
/// @AUTHOR : Jinal Soni
/// @DATE : 16-05-2024
/// @Message : [ImagePickerSelection]

class ImagePickerSelection {
  static final ImagePickerSelection _singleton = ImagePickerSelection._internal();

  ImagePickerSelection._internal();

  static ImagePickerSelection get instance => _singleton;

  // final ImagePicker _picker = ImagePicker();

  /// Check permission
  Future<bool> checkPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    bool status = false;
    if (permissionStatus.isDenied) {
      /// Permission denied we will ask for permission
      status = await requestForPermission(permission);
    } else if (permissionStatus.isGranted) {
      /// Permission is already granted.
      status = true;
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else if (permissionStatus.isRestricted) {
      /// Permission is OS restricted.
      status = false;
    }
    return status;
  }

  /// Request for permission if not granted
  Future<bool> requestForPermission(Permission permission) async {
    PermissionStatus status = await permission.request();

    /// Ask until user allow the permission
    if (status.isDenied) {
      requestForPermission(permission);
    }
    return status.isGranted;
  }

  /// GetCorrectPermission
  Future<Permission> getCorrectPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        /// use [Permissions.storage.status]
        debugPrint('requesting Storage Permission');
        return Permission.storage;
      } else {
        /// use [Permissions.photos.status]
        debugPrint('requesting Photos Permission');
        return Permission.photos;
      }
    }
    debugPrint('requesting Storage Permission iOS');
    return Permission.storage;
  }

  Future<void> onImageButtonPressed({
    int selectedMediaSize = 0,
    int maxSelectionLimit = 15,
    String from = '',
    required ImageSource mediaSource,
    BuildContext? context,
    required void Function(List<XFile>?) resultCallback, // Modified to handle multiple files
  }) async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          if (await Permission.storage.isDenied) {
            PermissionStatus status = await Permission.storage.request();
            if (!status.isGranted) {
              AppUtils.showErrorSnackBar('Storage permission is required to select files.');
              return;
            }
          }
        }
      }

      await getCorrectPermission();

      if (mediaSource == ImageSource.gallery) {
        int remainingCount = maxSelectionLimit - selectedMediaSize;

        if (from == 'GALLERY') {
          if (remainingCount <= 0) {
            AppUtils.showErrorSnackBar('You have reached the maximum selection limit of $maxSelectionLimit files.');
            return;
          }
        }
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: from == 'GALLERY', // Allow multiple selection only if from GALLERY
          type: from == 'GALLERY' ? FileType.media : FileType.image,
        );

        if (result != null) {
          List<String?> filePaths = result.files.map((file) => file.path).toList();

          // Check if the selection exceeds the remaining limit
          if (from == 'GALLERY' && filePaths.length > remainingCount) {
            AppUtils.showErrorSnackBar('You can select up to $remainingCount more files only.');
            return;
          }

          // Process selected files
          List<XFile> selectedFiles = [];
          for (String? filePath in filePaths) {
            if (filePath != null) {
              if (isVideo(filePath)) {
                // Check video duration
                VideoPlayerController testLengthController = VideoPlayerController.file(File(filePath));
                await testLengthController.initialize();

                if (testLengthController.value.duration.inSeconds > AppConstants.maxVideoLengthToUpload) {
                  debugPrint(
                      'Video too long. Maximum allowed duration is ${AppConstants.maxVideoLengthToUpload} seconds.');
                  AppUtils.showErrorSnackBar(AppConstants.videoDurationStr);
                } else {
                  selectedFiles.add(XFile(filePath));
                }

                testLengthController.dispose();
              } else {
                // Compress image
                final XFile? compressedFile = await ImageUtils.instance.compressImage(filePath);
                if (compressedFile != null) {
                  selectedFiles.add(compressedFile);
                } else {
                  selectedFiles.add(XFile(filePath));
                }
              }
            }
          }
          resultCallback.call(selectedFiles.isNotEmpty ? selectedFiles : null);
        } else {
          debugPrint('No file selected from gallery.');
        }
      } else if (mediaSource == ImageSource.camera) {
        try {
          final XFile? capturedFile;
          capturedFile = await ImagePicker().pickImage(source: ImageSource.camera);

          if (capturedFile != null) {
            // Compress image if needed
            final XFile? compressedImage = await ImageUtils.instance.compressImage(capturedFile.path);
            resultCallback.call([compressedImage ?? capturedFile]);
          }
        } catch (e) {
          debugPrint('Error in camera capture: $e');
          AppUtils.showErrorSnackBar('An error occurred while capturing with the camera.');
        }
      }
    } catch (e) {
      debugPrint('Error in onImageButtonPressed: $e');
      AppUtils.showErrorSnackBar('An error occurred while selecting files.');
    }
  }

  ///Action sheet for camera n gallery option for image picker
  void showActionSheet({required void Function() cameraFun, required void Function() galleryFun}) {
    showCupertinoModalPopup(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Choose an Option'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                cameraFun();
              },
              child: Text(
                'Camera',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                galleryFun();
              },
              child: Text(
                'Gallery',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }

  bool isVideo(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType?.startsWith('video/') ?? false;
  }
}
