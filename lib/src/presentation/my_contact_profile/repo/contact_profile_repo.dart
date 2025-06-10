import 'package:flutter/foundation.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/login_model_profile.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 25/03/25
/// @Message : [ContactProfileRepo]

class ContactProfileRepo {
  ContactProfileRepo._internal();

  static ContactProfileRepo instance = ContactProfileRepo._internal();

  Future<ResponseWrapper<ContactProfileModel>> getContactProfileDetails({int contactId = 0}) async {
    try {
      ResponseWrapper<dynamic> response =
          await ApiClient.instance.getApi(path: '${ApiConstant.contactProfile}$contactId');
      if (response.status) {
        ContactProfileModel model = ContactProfileModel.fromJson(response.responseData);
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
