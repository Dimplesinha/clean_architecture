import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/domain/api/api_exports.dart';
import 'package:workapp/src/domain/models/cms_model.dart';
import 'package:workapp/src/domain/models/models_export.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt. Ltd.
/// @DATE : 29-09-2024
/// @Message : [CmsTypeRepository]

class CmsTypeRepository {
  static final CmsTypeRepository _singleton = CmsTypeRepository._internal();

  CmsTypeRepository._internal();

  static CmsTypeRepository get instance => _singleton;

  Future<ResponseWrapper<CMSTypeModel>> fetchCMSContent({required int cmsTypeId}) async {
    try {
      var response = await ApiClient.instance.getApi(
        path: '${ApiConstant.cmsType}$cmsTypeId',
      );
      if (response.status) {
        CMSTypeModel cmsData = CMSTypeModel.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: cmsData);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
