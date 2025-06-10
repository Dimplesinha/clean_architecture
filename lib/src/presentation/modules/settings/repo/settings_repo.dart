/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12-12-2024
/// @Message : [SettingsRepo]

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';

class SettingsRepo {
  static final SettingsRepo _singleton = SettingsRepo._internal();

  SettingsRepo._internal();

  static SettingsRepo get instance => _singleton;

  //onSubmitTap() Used to call api.
  Future<ResponseWrapper<LoginResponse?>?> onLinkAccountTap({BuildContext? context, Map<String, dynamic>? json}) async {
    try {
      var response = await ApiClient.instance.linkAccountPutApi(
        path: ApiConstant.linkAccount,
        requestBody: json,
        isBodyInArray: false,
      );
      if (response.status) {
        LoginResponse model = LoginResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('');
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
