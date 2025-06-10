import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FilePickerUtility {
  static Future<File?> getFile({List<String>? allowedFileTypes}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedFileTypes, // ['jpg', 'pdf', 'doc']
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        return file;
      } else {
        if (kDebugMode) {
          print('User canceled the picker');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
    return null;
  }

  static Future<List<XFile>?> getFiles({bool multiFilesAllowed = false, List<String>? allowedFileTypes}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: multiFilesAllowed,
        type: FileType.custom,
        allowedExtensions: allowedFileTypes, // ['jpg', 'pdf', 'doc']
      );
      if (result != null) {
        return result.xFiles;
      } else {
        if (kDebugMode) {
          print('User canceled the picker');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
    return null;
  }
}
