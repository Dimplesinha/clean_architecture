import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';

class ContactUsRepo {
  static final ContactUsRepo _singleton = ContactUsRepo._internal();

  ContactUsRepo._internal();

  static ContactUsRepo get instance => _singleton;

  //onSubmitTap() Used to call api.
  Future<ResponseWrapper<ContactModel?>?> onSubmitTap(BuildContext context,
      {required Map<String, dynamic> json}) async {
    try {
      var response = await ApiClient.instance.contactUsApi(
        path: ApiConstant.contactUsApi,
        requestBody: json,
        isBodyInArray: false,
      );
      if (response.status) {
        ContactModel model = ContactModel.fromJson(response.responseData);
        return ResponseWrapper(
            status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return ResponseWrapper(
          status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
