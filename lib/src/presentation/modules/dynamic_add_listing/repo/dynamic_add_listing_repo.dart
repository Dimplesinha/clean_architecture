import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_category.dart';
import 'package:workapp/src/domain/models/asset_model.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 05/03/25
/// @Message : [DynamicAddListingRepository]

class DynamicAddListingRepository {
  static final DynamicAddListingRepository _dynamicAddListingRepository = DynamicAddListingRepository._internal();

  DynamicAddListingRepository._internal();

  static DynamicAddListingRepository get instance => _dynamicAddListingRepository;

  Future<ResponseWrapper<AddListingCategory>> getListOfCategory() async {
    try {
      var response = await ApiClient.instance.getApi(
        path: ApiConstant.dynamicAddListingCategoryList,
      );
      if (response.status) {
        AddListingCategory model = AddListingCategory.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
