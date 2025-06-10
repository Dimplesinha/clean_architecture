import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:path/path.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/repo/profile_basic_details_repo.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/network_utils.dart';

part 'my_account_state.dart';

class MyAccountCubit extends Cubit<MyAccountState> {
  ProfileBasicDetailsRepo profileBasicDetailsRepo;

  MyAccountCubit({required this.profileBasicDetailsRepo}) : super(MyAccountInitial());

  void init() async {
    try {
      emit(MyAccountLoaded(loader: true));
      var response = await profileBasicDetailsRepo.getProfileBasicDetails();
      var oldState = state as MyAccountLoaded;
      emit(oldState.copyWith(
        loader: false,
        profileBasicDetailsModel: response.responseData,
      ));
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  Future<void> onSelectImage(
    BuildContext context, {
    required String imagePath,
  }) async {
    try {
      var response = await profileBasicDetailsRepo.getProfileBasicDetails();

      emit(MyAccountLoaded(loader: true, profileBasicDetailsModel: response.responseData));

      (String?, File?, String?)? azureData = await uploadToAzure(context, imagePath);
      if (azureData == null) {
        return;
      }
      // oldState.copyWith(loader: false);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<(String?, File?, String?)?> uploadToAzure(BuildContext context, String fileLocalPath) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return AppUtils.showSnackBar(AppConstants.internetNotAvailableStr, SnackBarType.fail);
      }
      ///Renaming file to timestamp with extension
      File? renamedFile = await AppUtils.renameFileWithTimestamp(File(fileLocalPath));
      String fileName = basename(renamedFile?.path ?? '');


      String base64File = await AppUtils.convertFileToBase64(renamedFile?.path ?? '');
      onImageUpload(
        context,
        imageName: fileName,
          base64File:base64File
      );
    } catch (e) {
      emit(MyAccountLoaded(loader: false));
      if (kDebugMode) print('.uploadToAzure--$e');
      AppUtils.showSnackBar(AppConstants.somethingWentWrong, SnackBarType.fail);
      return null;
    }
    return null;
  }

  /// Api call to update profile picture
  Future<void> onImageUpload(
    BuildContext context, {
    required String imageName,
    required String base64File,
  }) async {
    try {

      var userData = await profileBasicDetailsRepo.getProfileBasicDetails();

      emit(MyAccountLoaded(loader: true, profileBasicDetailsModel: userData.responseData));

      Map<String, dynamic> requestBody = {
        ModelKeys.imageName: imageName,
        ModelKeys.base64: base64File,
      };

      var response = await profileBasicDetailsRepo.updateProfile(requestBody);
      if (response.status) {
        await PreferenceHelper.instance.updateProfile(response.responseData?.result?.profileURL ?? '');
        init();
        AppUtils.showSnackBar(response.message, SnackBarType.success);
        emit(MyAccountLoaded(loader: false));
      } else {
        init();
        emit(MyAccountLoaded(loader: false));
        AppUtils.showSnackBar(response.message, SnackBarType.fail);
      }
    } catch (e) {
      init();
      AppUtils.showSnackBar(e.toString(), SnackBarType.fail);
    }
  }
}
